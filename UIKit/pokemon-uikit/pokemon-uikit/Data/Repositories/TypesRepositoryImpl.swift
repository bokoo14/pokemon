//
//  TypesRepositoryImp.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import Alamofire
import Combine
import Foundation

class TypesRepositoryImpl: TypesRepository {
    private let baseURL: URL
    private let networkService: NetworkService
    
    init(baseURL: URL, networkService: NetworkService) {
        self.baseURL = baseURL
        self.networkService = networkService
    }
    
    func fetchTypes() async throws -> [String] {
        let request = GetTypesRequest(
            baseURL: baseURL
        )
        let response = try await networkService.request(request)
        return response.data
    }
    
    func fetchTypesPublisher() -> AnyPublisher<[String], Error> {
        return Future<[String], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "Repository deallocated", code: -1)))
                return
            }
            
            Task {
                do {
                    let supertypes = try await self.fetchTypes()
                    promise(.success(supertypes))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
