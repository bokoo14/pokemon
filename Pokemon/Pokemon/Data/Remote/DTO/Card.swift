//
//  Card.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Foundation

struct CardResponse: Decodable {
    let data: [Card]
}

struct Card: Decodable {
  let id: String
  let name: String
  let supertype: String
  let types: [String]?
  let images: ImageURLs
  let set: SetInfo
}

struct ImageURLs: Decodable {
  let small: URL
  let large: URL
}

struct SetInfo: Decodable {
  let images: SetImages
}

struct SetImages: Decodable {
  let symbol: URL
  let logo: URL
}


extension Card {
    func toDomain(isFavorite: Bool = false) -> Pokemon {
        Pokemon(
            id: id,
            name: name,
            imageURL: images.small.absoluteString,
            isFavorite: isFavorite
        )
    }
}
