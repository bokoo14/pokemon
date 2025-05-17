//
//  PokemonCardView.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Kingfisher
import SwiftUI

struct PokemonCardView: View {
    let pokemon: Pokemon
    let onToggleFavorite: () -> Void
    
    var body: some View {
        NavigationLink {
            PokemonDetailView(pokemon: pokemon, onToggleFavorite: onToggleFavorite)
        } label: {
            VStack {
                if !pokemon.imageURL.isEmpty, let url = URL(string: pokemon.imageURL) {
                    KFImage(url)
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .aspectRatio(0.75, contentMode: .fit)
                        }
                        .aspectRatio(0.75, contentMode: .fit)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(0.75, contentMode: .fit)
                }
                
                HStack {
                    Text(pokemon.name)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    Spacer()
                    Button {
                        onToggleFavorite()
                    } label: {
                        Image(systemName: pokemon.isFavorite ? "star.fill" : "star")
                            .foregroundStyle(pokemon.isFavorite ? .yellow : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.vertical, 4)
            }
            .padding(10)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 10)
        }
    }
}

#Preview() {
    NavigationView {
        PokemonCardView(pokemon:
                            Pokemon(id: "1", name: "포켓몬 1", imageURL: "https://images.pokemontcg.io/base1/58.png", types: [""], logoImage: "", isFavorite: true), onToggleFavorite: {}
        )
    }
}
