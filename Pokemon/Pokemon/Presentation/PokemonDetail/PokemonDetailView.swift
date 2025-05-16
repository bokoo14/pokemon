//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by bokyung on 5/16/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    let onToggleFavorite: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 카드 이미지
                if !pokemon.imageURL.isEmpty, let url = URL(string: pokemon.imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                        default:
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                                .frame(height: 300)
                        }
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                } else {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .frame(height: 300)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                
                // 이름
                Text(pokemon.name)
                    .font(.title)
                    .bold()
                
                // 로고 이미지
                if !pokemon.logoImage.isEmpty, let setUrl = URL(string: pokemon.logoImage) {
                    AsyncImage(url: setUrl) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50)
                        default:
                            EmptyView()
                        }
                    }
                }
                
                // 상세 정보
                VStack(spacing: 16) {
                    HStack {
                        Text("포켓몬 정보")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button {
                            onToggleFavorite()
                        } label: {
                            Image(systemName: pokemon.isFavorite ? "star.fill" : "star")
                                .font(.title2)
                                .foregroundColor(pokemon.isFavorite ? .yellow : .gray)
                        }
                    }
                    Divider()
                    InfoRow(title: "이름", value: pokemon.name)
                    InfoRow(title: "아이디", value: pokemon.id)
                    TypeBadge(title: "타입", values: pokemon.types ?? [])
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview("피카츄 이미지") {
    PokemonDetailView(pokemon:
                        Pokemon(id: "ex13-10", name: "피카츄", imageURL: "https://images.pokemontcg.io/base1/58.png", types: ["Fire", "Metal", "Water", "Winter"], logoImage: "https://images.pokemontcg.io/ex13/logo.png", isFavorite: true),
                      onToggleFavorite: {})
}

#Preview("이미지 없는 경우") {
    PokemonDetailView(pokemon:
                        Pokemon(id: "ex13-10", name: "피카츄", imageURL: "", types: ["Fire", "Metal", "Water"], logoImage: "https://images.pokemontcg.io/ex13/logo.png", isFavorite: true),
                      onToggleFavorite: {}
    )
}
