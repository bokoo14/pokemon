//
//  FetchPokemonUseCase.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Combine
import Foundation

protocol FetchPokemonUseCase {
    func execute(page: Int, searchText: String?, selectedSuperType: String?, selectedTypes: Set<String>) -> AnyPublisher<[Pokemon], Error>
}
