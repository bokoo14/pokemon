//
//  FavoritePokemonRepository.swift
//  Pokemon
//
//  Created by bokyung on 5/18/25.
//

import Combine
import Foundation

protocol FavoritePokemonRepository {
    func isFavorite(pokemonId: String) -> AnyPublisher<Bool, Error>
    func addFavorite(pokemon: Pokemon) -> AnyPublisher<Void, Error>
    func removeFavorite(pokemonId: String) -> AnyPublisher<Void, Error>
    func getFavoriteIds() -> AnyPublisher<[String], Error>
}
