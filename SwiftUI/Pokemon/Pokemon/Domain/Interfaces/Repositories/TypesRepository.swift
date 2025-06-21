//
//  TypesRepository.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import Combine
import Foundation

protocol TypesRepository {
    func fetchTypes() async throws -> [String]
    func fetchTypesPublisher() -> AnyPublisher<[String], Error>
}
