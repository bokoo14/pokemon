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
