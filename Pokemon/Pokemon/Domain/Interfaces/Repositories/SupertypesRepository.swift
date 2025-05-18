//
//  SupertypesRepository.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import Combine
import Foundation

protocol SupertypesRepository {
    func fetchSupertypes() async throws -> [String]
    func fetchSupertypesPublisher() -> AnyPublisher<[String], Error>
}
