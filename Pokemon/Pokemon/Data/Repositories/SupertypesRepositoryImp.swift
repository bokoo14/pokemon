//
//  SupertypesRepositoryImp.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import Alamofire
import Combine
import Foundation

class SupertypesRepositoryImp: SupertypesRepository {
    private let baseURL: URL
    private let networkService: NetworkService
    
    init(baseURL: URL, networkService: NetworkService) {
        self.baseURL = baseURL
        self.networkService = networkService
    }
    
    func fetchSupertypes() async throws -> [String] {
        let request = GetSupertypesRequest(
            baseURL: baseURL
        )
        let response = try await networkService.request(request)
        return response.data
    }
    
    func fetchSupertypesPublisher() -> AnyPublisher<[String], Error> {
        return Future<[String], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "Repository deallocated", code: -1)))
                return
            }
            
            Task {
                do {
                    let supertypes = try await self.fetchSupertypes()
                    promise(.success(supertypes))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
