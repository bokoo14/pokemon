//
//  FetchFavoritePokemonUseCase.swift
//  Pokemon
//
//  Created by bokyung on 5/18/25.
//

import Combine
import Foundation

protocol FetchFavoritePokemonUseCase {
    func execute() -> AnyPublisher<[Pokemon], Error>
}

class FetchFavoritePokemonUseCaseImpl: FetchFavoritePokemonUseCase {
    private let repository: FavoritePokemonRepository
    
    init(repository: FavoritePokemonRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Pokemon], Error> {
        repository.getFavoritePokemons()
            .map { entities in
                entities.compactMap { entity in
                    return Pokemon(
                        id: entity.id ?? "",
                        name: entity.name ?? "",
                        supertype: entity.supertype ?? "",
                        types: entity.types as? [String],
                        imageURL: entity.imageURL ?? "",
                        logoImage: entity.logoImage ?? "",
                        isFavorite: entity.isFavorite
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
