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
