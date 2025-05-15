//
//  PokemonListView.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import SwiftUI

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            // 즐겨찾기
            HStack {
                Spacer()
                Toggle(isOn: $viewModel.showFavoritesOnly) {
                    Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star")
                        .foregroundStyle(.yellow)
                }
                .toggleStyle(.button)
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            
            // 검색창
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                TextField("검색하세요", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)

            // 카드 리스트
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    if viewModel.isLoading {
                        // 로딩 중 - Skeleton UI
                        ForEach(0..<10, id: \.self) { _ in
                            SkeletonCardView()
                        }
                    } else {
                        ForEach(viewModel.filteredPokemons) { pokemon in
                            PokemonCardView(
                                pokemon: pokemon,
                                onToggleFavorite: {
                                    viewModel.toggleFavorite(for: pokemon.id)
                                }
                            )
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    PokemonListView()
}

