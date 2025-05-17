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

class FetchTypesUseCaseImp: FetchTypesUseCase {
    private let repository: TypesRepository
    
    init(repository: TypesRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[String], Error> {
        return repository.fetchTypesPublisher()
            .eraseToAnyPublisher()
    }
}
