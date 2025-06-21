//
//  Network.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Alamofire
import Foundation

class NetworkServiceImp: NetworkService {
    func request<R: Request>(_ request: R) async throws -> R.Output {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                request.endpoint,
                method: HTTPMethod(rawValue: request.method.rawValue),
                parameters: request.query,
                headers: request.header
            )
            .validate()
            .responseDecodable(of: R.Output.self) { response in
                switch response.result {
                case .success(let output):
                    continuation.resume(returning: output)
                    print("output: \(output)")
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            .cURLDescription { description in
                print("cURL: \(description)")
            }
        }
    }
}
