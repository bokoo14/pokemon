//
//  PokemonCardQueryBuilder.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import Foundation

class PokemonCardQueryBuilder {
    private var searchText: String?
    private var superType: String?
    private var types: Set<String> = []
    
    func withName(_ name: String?) -> Self {
        self.searchText = name
        return self
    }
    
    func withSuperType(_ superType: String?) -> Self {
        self.superType = superType
        return self
    }
    
    func withTypes(_ types: Set<String>) -> Self {
        self.types = types
        return self
    }
    
    var luceneQuery: String? {
        var queries = [String]()
        if let superType = superType {
            queries.append("supertype:\(superType)")
        }
        for type in types {
            queries.append("types:\(type)")
        }
        if let text = searchText, !text.isEmpty {
            queries.append("name:\"*\(text)*\"")
        }
        return queries.isEmpty ? nil : queries.joined(separator: " ")
    }
}
