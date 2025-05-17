//
//  FetchPokemonUseCase.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Combine
import Foundation

protocol FetchPokemonUseCase {
    func execute(page: Int, query: String?) -> AnyPublisher<[Pokemon], Error>
}

class FetchPokemonUseCaseImp: FetchPokemonUseCase {
    private let repository: PokemonCardRepository
    
    init(repository: PokemonCardRepository) {
        self.repository = repository
    }
    
    func execute(page: Int, query: String?) -> AnyPublisher<[Pokemon], Error> {
        return repository.fetchCardsPublisher(page: page, query: query)
            .eraseToAnyPublisher()
    }
}
