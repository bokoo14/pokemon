//
//  GetSupertypesRequest.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import Alamofire
import Foundation

struct GetSupertypesRequest: Request {
    typealias Output = SuperTypesResponse

    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeaders

    init(baseURL: URL) {
        self.endpoint = baseURL.appendingPathComponent("/v2/supertypes")
        self.method = .get
        self.query = [:]
        self.header = [:]
    }
}
