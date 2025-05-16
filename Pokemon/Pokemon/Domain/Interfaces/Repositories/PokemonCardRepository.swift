//
//  PokemonCardRepository.swift
//  Pokemon
//
//  Created by bokyung on 5/16/25.
//

import Combine
import Foundation

protocol PokemonCardRepository {
    func fetchCards(page: Int, query: String?) async throws -> [Pokemon]
    func fetchCardsPublisher(page: Int, query: String?) -> AnyPublisher<[Pokemon], Error>
}
