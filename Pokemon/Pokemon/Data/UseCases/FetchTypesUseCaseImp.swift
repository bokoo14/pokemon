//
//  FetchTypesUseCaseImp.swift
//  Pokemon
//
//  Created by bokyung on 5/18/25.
//

import Combine
import Foundation

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
