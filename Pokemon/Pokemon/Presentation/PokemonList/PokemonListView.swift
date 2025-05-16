//
//  PokemonListView.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import SwiftUI
import Swinject

struct PokemonListView: View {
    @StateObject private var viewModel: PokemonListViewModel
        
    init() {
        let resolvedViewModel = DependencyContainer.shared.container.resolve(PokemonListViewModel.self)!
        _viewModel = StateObject(wrappedValue: resolvedViewModel)
    }
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            // 즐겨찾기
            HStack {
                Spacer()
                Toggle(isOn: $viewModel.isShowFavoritesOnly) {
                    Image(systemName: viewModel.isShowFavoritesOnly ? "star.fill" : "star")
                        .foregroundStyle(viewModel.isShowFavoritesOnly ? .yellow : .gray)
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
                    ForEach(viewModel.filteredPokemons) { pokemon in
                        PokemonCardView(
                            pokemon: pokemon,
                            onToggleFavorite: {
                                viewModel.toggleFavorite(for: pokemon.id)
                            }
                        )
                    }
                    if !viewModel.isShowFavoritesOnly {
                        if viewModel.isLoadingMore {
                            ProgressView()
                                .gridCellColumns(2)
                        } else if viewModel.hasMoreData {
                            Color.clear
                                .frame(height: 50)
                                .gridCellColumns(2)
                                .onAppear {
                                    viewModel.loadMoreIfNeeded()
                                }
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
