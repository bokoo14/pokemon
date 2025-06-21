//
//  FetchSupertypesUseCaseImp.swift
//  Pokemon
//
//  Created by bokyung on 5/18/25.
//

import Combine
import Foundation

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
