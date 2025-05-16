//
//  GetPokemontsRequest.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Alamofire
import Foundation

struct GetPokemonsRequest: Request {
    typealias Output = CardResponse

    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeaders

    init(baseURL: URL, page: Int = 1, queryText: String? = nil, selectFields: [String] = ["id", "name", "supertype", "types", "images", "set"]) {
        self.endpoint = baseURL.appendingPathComponent("/v2/cards")
        self.method = .get

        var queryItems: [String: String] = [
            "page": "\(page)",
            "pageSize": "20",
            "select": selectFields.joined(separator: ",")
        ]

        if let queryText = queryText {
            queryItems["q"] = queryText
        }

        self.query = queryItems
        self.header = [:]
    }
}
