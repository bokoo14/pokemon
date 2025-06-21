//
//  Request.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Alamofire
import Foundation

typealias QueryItems = [String: Any]
typealias HTTPHeader = [String: String]

protocol Request {
    associatedtype Output: Decodable

    var endpoint: URL { get }
    var method: HTTPMethod { get }
    var query: QueryItems { get }
    var header: HTTPHeaders { get }
}
