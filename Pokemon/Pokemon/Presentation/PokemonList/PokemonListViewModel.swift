//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import Combine
import Foundation

class PokemonListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    @Published var isLoading: Bool = true
    @Published var pokemons: [Pokemon] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    var filteredPokemons: [Pokemon] {
        var list = pokemons
        if showFavoritesOnly {
            list = list.filter { $0.isFavorite }
        }
        if !searchText.isEmpty {
            list = list.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return list
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.pokemons = (1...20).map {
                Pokemon(id: $0, name: "포켓몬 \($0)", imageURL: "", isFavorite: false)
            }
            self.isLoading = false
        }
    }
    
    func toggleFavorite(for pokemonId: Int) {
        if let index = pokemons.firstIndex(where: { $0.id == pokemonId }) {
            let pokemon = pokemons[index]
            pokemons[index] = Pokemon(
                id: pokemon.id,
                name: pokemon.name,
                imageURL: pokemon.imageURL,
                isFavorite: !pokemon.isFavorite
            )
        }
    }
}
