//
//  ToggleFavoriteUseCase.swift
//  Pokemon
//
//  Created by bokyung on 5/18/25.
//

import Combine
import Foundation

protocol ToggleFavoriteFavoriteUseCase {
    func execute(pokemon: Pokemon) -> AnyPublisher<Bool, Error>
}

class ToggleFavoriteFavoriteUseCaseImp: ToggleFavoriteFavoriteUseCase {
    private let repository: FavoritePokemonRepository
    
    init(repository: FavoritePokemonRepository) {
        self.repository = repository
    }
    
    func execute(pokemon: Pokemon) -> AnyPublisher<Bool, Error> {
        return repository.isFavorite(pokemonId: pokemon.id)
            .flatMap { [weak self] isFavorite -> AnyPublisher<Bool, Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "UseCase", code: -1, userInfo: [NSLocalizedDescriptionKey: "UseCase instance is nil"]))
                        .eraseToAnyPublisher()
                }
                
                if isFavorite {
                    return self.repository.removeFavorite(pokemonId: pokemon.id)
                        .map { _ in false }
                        .eraseToAnyPublisher()
                } else {
                    return self.repository.addFavorite(pokemon: pokemon)
                        .map { _ in true }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
