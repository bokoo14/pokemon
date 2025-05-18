//
//  Pokemon.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Foundation

struct Pokemon: Identifiable {
    let id: String
    let name: String
    let supertype: String
    let types: [String]?
    let imageURL: String
    let logoImage: String
    var isFavorite: Bool
}
