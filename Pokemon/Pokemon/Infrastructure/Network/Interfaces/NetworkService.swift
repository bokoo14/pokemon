//
//  NetworkService.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import Foundation

protocol NetworkService {
    func request<R: Request>(_ request: R) async throws -> R.Output
}
