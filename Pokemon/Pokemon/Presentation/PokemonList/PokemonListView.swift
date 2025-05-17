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
    
    private let excludedSuperTypesForTypesFilter: [String] = ["Trainer"]
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        let resolvedViewModel = DependencyContainer.shared.container.resolve(PokemonListViewModel.self)!
        _viewModel = StateObject(wrappedValue: resolvedViewModel)
    }
    
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
            .padding(.horizontal, 10)
            
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
            .padding(.horizontal, 10)
            
            // Supertypes 필터
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.superTypes, id: \.self) { superType in
                        SelectableRoundedButton(
                            title: superType,
                            isSelected: viewModel.selectedSuperType == superType,
                            action: {
                                viewModel.handleSuperTypeSelection(superType)
                            }
                        )
                    }
                }
                .padding(.horizontal, 10)
            }
            
            // Types 필터 (Trainer가 아닌 경우만 노출)
            if let selected = viewModel.selectedSuperType,
               !excludedSuperTypesForTypesFilter.contains(selected) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.types, id: \.self) { type in
                            SelectableRoundedButton(
                                title: type,
                                isSelected: viewModel.selectedTypes.contains(type),
                                action: {
                                    viewModel.toggleTypeSelection(type)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            
            // 카드 리스트
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    if viewModel.isLoading {
                        ForEach(0..<10, id: \.self) { _ in
                            SkeletonCardView()
                        }
                    } else {
                        Group {
                            if viewModel.filteredPokemons.isEmpty {
                                resetFilterButton
                                    .gridCellColumns(10)
                            } else {
                                pokemonCardList
                            }
                        }
                    }
                    // 스크롤 시 해당 섹션 도달 시 더 불러오기
                    loadMoreSection
                }
            }
        }
    }
    
    private var resetFilterButton: some View {
        Button {
            viewModel.resetFilters()
        } label: {
            Text("필터 초기화")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    
    private var pokemonCardList: some View {
        ForEach(viewModel.filteredPokemons) { pokemon in
            PokemonCardView(
                pokemon: pokemon,
                onToggleFavorite: {
                    viewModel.toggleFavorite(for: pokemon.id)
                }
            )
        }
    }
    
    private var loadMoreSection: some View {
        Group {
            if !viewModel.isShowFavoritesOnly {
                if viewModel.isLoadingMore {
                    ProgressView()
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
    }
}

#Preview {
    PokemonListView()
}
