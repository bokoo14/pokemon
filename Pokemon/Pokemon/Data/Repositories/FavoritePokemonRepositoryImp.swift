//
//  FavoritePokemonRepositoryImp.swift
//  Pokemon
//
//  Created by bokyung on 5/18/25.
//

import Combine
import CoreData
import Foundation

enum RepositoryError: Error {
    case instanceDeallocated
    case coreDataError(Error)
}

class FavoritePokemonRepositoryImp: FavoritePokemonRepository {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func isFavorite(pokemonId: String) -> AnyPublisher<Bool, Error> {
        Deferred {
            Result {
                try self.fetchFavoritePokemon(by: pokemonId).isEmpty == false
            }
            .mapError { RepositoryError.coreDataError($0) }
            .publisher
        }
        .eraseToAnyPublisher()
    }

    func addFavorite(pokemon: Pokemon) -> AnyPublisher<Void, Error> {
        Deferred {
            Result {
                let exists = try self.fetchFavoritePokemon(by: pokemon.id).isEmpty == false
                guard !exists else { return }

                let favorite = FavoritePokemon(context: self.viewContext)
                favorite.id = pokemon.id
                favorite.name = pokemon.name
                favorite.types = pokemon.types as NSArray?
                favorite.supertype = pokemon.supertype
                favorite.imageURL = pokemon.imageURL
                favorite.logoImage = pokemon.logoImage

                try self.viewContext.save()
            }
            .mapError { RepositoryError.coreDataError($0) }
            .publisher
        }
        .eraseToAnyPublisher()
    }

    func removeFavorite(pokemonId: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Result {
                let items = try self.fetchFavoritePokemon(by: pokemonId)
                for item in items {
                    self.viewContext.delete(item)
                }
                try self.viewContext.save()
            }
            .mapError { RepositoryError.coreDataError($0) }
            .publisher
        }
        .eraseToAnyPublisher()
    }

    func getFavoriteIds() -> AnyPublisher<[String], Error> {
        Deferred {
            Result {
                let fetchRequest: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
                let results = try self.viewContext.fetch(fetchRequest)
                return results.compactMap { $0.id }
            }
            .mapError { RepositoryError.coreDataError($0) }
            .publisher
        }
        .eraseToAnyPublisher()
    }

    // MARK: Helper
    
    private func fetchFavoritePokemon(by id: String) throws -> [FavoritePokemon] {
        let request: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return try viewContext.fetch(request)
    }
}

