//
//  PokemonCardRepository.swift
//  Pokemon
//
//  Created by bokyung on 5/16/25.
//

import Combine
import Foundation

protocol PokemonCardRepository {
    func fetchCards(page: Int, searchText: String?, selectedSuperType: String?, selectedTypes: Set<String>) async throws -> [Pokemon]
    func fetchCardsPublisher(page: Int, searchText: String?, selectedSuperType: String?, selectedTypes: Set<String>) -> AnyPublisher<[Pokemon], Error>
}
