//
//  FetchSupertypesUseCase.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import Combine
import Foundation

protocol FetchSupertypesUseCase {
    func execute() -> AnyPublisher<[String], Error>
}

class FetchSupertypesUseCaseImp: FetchSupertypesUseCase {
    private let repository: SupertypesRepository
    
    init(repository: SupertypesRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[String], Error> {
        return repository.fetchSupertypesPublisher()
            .eraseToAnyPublisher()
    }
}
