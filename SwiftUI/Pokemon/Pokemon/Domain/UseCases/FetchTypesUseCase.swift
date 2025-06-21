//
//  FetchTypesUseCase.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import Combine
import Foundation

protocol FetchTypesUseCase {
    func execute() -> AnyPublisher<[String], Error>
}
