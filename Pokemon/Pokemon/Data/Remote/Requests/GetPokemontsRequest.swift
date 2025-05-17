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

    init(
        baseURL: URL,
        page: Int = 1,
        searchText: String? = nil,
        selectedSuperType: String? = nil,
        selectedTypes: Set<String> = [],
        selectFields: [String] = ["id", "name", "supertype", "types", "images", "set"]
    ) {
        self.endpoint = baseURL.appendingPathComponent("/v2/cards")
        self.method = .get
        
        var queryItems: [String: String] = [
            "page": "\(page)",
            "pageSize": "20",
            "select": selectFields.joined(separator: ",")
        ]
        let queryBuilder = PokemonCardQueryBuilder()
            .withName(searchText)
            .withSuperType(selectedSuperType)
            .withTypes(selectedTypes)
        if let q = queryBuilder.luceneQuery {
            queryItems["q"] = q
        }
        
        self.query = queryItems
        self.header = [:]
    }
}
