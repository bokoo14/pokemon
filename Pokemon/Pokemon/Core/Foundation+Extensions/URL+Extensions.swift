//
//  URL+Extensions.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Foundation

extension URL {
    func appending(_ path: String) -> URL {
        return appendingPathComponent(path)
    }
    
    func appendingQuery(key: String, value: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
        var queryItems = components.queryItems ?? []
        queryItems.append(.init(name: key, value: value))
        components.queryItems = queryItems
        guard let url = components.url else { return self }
        return url
    }
}
