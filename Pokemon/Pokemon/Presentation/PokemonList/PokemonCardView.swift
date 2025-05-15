//
//  PokemonCardView.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import SwiftUI

struct PokemonCardView: View {
    let pokemon: Pokemon
    let onToggleFavorite: () -> Void
    
    var body: some View {
        VStack {
            if !pokemon.imageURL.isEmpty, let url = URL(string: pokemon.imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(1, contentMode: .fit)
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1, contentMode: .fit)
            }
            
            HStack {
                Text(pokemon.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: onToggleFavorite) {
                    Image(systemName: pokemon.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(pokemon.isFavorite ? .yellow : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical, 4)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    PokemonCardView(pokemon:
                        Pokemon(id: 1, name: "포켓몬 1", imageURL: "", isFavorite: true), onToggleFavorite: {}
    )
}
