//
//  FetchPokemonUseCaseImp.swift
//  Pokemon
//
//  Created by bokyung on 5/18/25.
//

import Combine
import Foundation

class FetchPokemonUseCaseImp: FetchPokemonUseCase {
    private let repository: PokemonCardRepository
    
    init(repository: PokemonCardRepository) {
        self.repository = repository
    }
    
    func execute(page: Int, searchText: String?, selectedSuperType: String?, selectedTypes: Set<String>) -> AnyPublisher<[Pokemon], Error> {
        return repository.fetchCardsPublisher(page: page, searchText: searchText, selectedSuperType: selectedSuperType, selectedTypes: selectedTypes)
            .eraseToAnyPublisher()
    }
}
