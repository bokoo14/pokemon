//
//  PokemonCardRepositoryImp.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Alamofire
import Combine
import CoreData
import Foundation

class PokemonCardRepositoryImpl: PokemonCardRepository {
    private let baseURL: URL
    private let networkService: NetworkService
    private let context: NSManagedObjectContext

    init(baseURL: URL, networkService: NetworkService, context: NSManagedObjectContext) {
        self.baseURL = baseURL
        self.networkService = networkService
        self.context = context
    }
    
    func fetchCards(page: Int, searchText: String?, selectedSuperType: String?, selectedTypes: Set<String>) async throws -> [Pokemon] {
        let request = GetPokemonsRequest(
            baseURL: baseURL,
            page: page,
            searchText: searchText,
            selectedSuperType: selectedSuperType,
            selectedTypes: selectedTypes
        )
        let response = try await networkService.request(request)
        let fetchedPokemons = response.data.map { $0.toDomain() }
        let favoritePokemonIds = fetchFavoritePokemonIds()
        
        return fetchedPokemons.map { pokemon in
            Pokemon(
                id: pokemon.id,
                name: pokemon.name,
                supertype: pokemon.supertype,
                types: pokemon.types,
                imageURL: pokemon.imageURL,
                logoImage: pokemon.logoImage,
                isFavorite: favoritePokemonIds.contains(pokemon.id)
            )
        }
    }
    
    func fetchCardsPublisher(page: Int, searchText: String?, selectedSuperType: String?, selectedTypes: Set<String>) -> AnyPublisher<[Pokemon], Error> {
        return Future<[Pokemon], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "Repository deallocated", code: -1)))
                return
            }
            
            Task {
                do {
                    let pokemons = try await self.fetchCards(page: page, searchText: searchText, selectedSuperType: selectedSuperType, selectedTypes: selectedTypes)
                    promise(.success(pokemons))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: Helper
    
    private func fetchFavoritePokemonIds() -> Set<String> {
        let fetchRequest: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
        do {
            let favorites = try context.fetch(fetchRequest)
            return Set(favorites.compactMap { $0.id })
        } catch {
            print("CoreData fetch error:", error)
            return []
        }
    }
}
