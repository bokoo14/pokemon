//
//  PokemonCardRepositoryImp.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Alamofire
import Combine
import Foundation

class PokemonCardRepositoryImp: PokemonCardRepository {
    private let baseURL: URL
    private let networkService: NetworkService
    
    init(baseURL: URL, networkService: NetworkService) {
        self.baseURL = baseURL
        self.networkService = networkService
    }
    
    func fetchCards(page: Int, query: String?) async throws -> [Pokemon] {
        let request = GetPokemonsRequest(
            baseURL: baseURL,
            page: page,
            queryText: query
        )
        let response = try await networkService.request(request)
        return response.data.map { $0.toDomain() }
    }
    
    func fetchCardsPublisher(page: Int, query: String?) -> AnyPublisher<[Pokemon], Error> {
        return Future<[Pokemon], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "Repository deallocated", code: -1)))
                return
            }
            
            Task {
                do {
                    let pokemons = try await self.fetchCards(page: page, query: query)
                    promise(.success(pokemons))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
