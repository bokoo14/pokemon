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
    @Published var isShowFavoritesOnly: Bool = false
    @Published var isLoading: Bool = false
    @Published var pokemons: [Pokemon] = []
    @Published var errorMessage: String?
    @Published var isLoadingMore: Bool = false
    @Published var hasMoreData: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private let loadPokemonUseCase: LoadPokemonUseCase
    private var currentPage = 1
    private var isRequestInProgress = false

    var filteredPokemons: [Pokemon] {
        var list = pokemons
        if isShowFavoritesOnly {
            list = list.filter { $0.isFavorite }
        }
        if !searchText.isEmpty {
            list = list.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return list
    }

    init(loadPokemonUseCase: LoadPokemonUseCase) {
        self.loadPokemonUseCase = loadPokemonUseCase
        setupSearchTextSubscription()
        loadData()
    }

    func loadData(refresh: Bool = true) {
        if isRequestInProgress { return }
        
        if refresh {
            isLoading = true
            currentPage = 1
            errorMessage = nil
        } else {
            isLoadingMore = true
        }
        
        isRequestInProgress = true
        
        let query = searchText.isEmpty ? nil : searchText
        
        loadPokemonUseCase.execute(page: currentPage, query: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isRequestInProgress = false
                
                if refresh {
                    self.isLoading = false
                } else {
                    self.isLoadingMore = false
                }
                
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("데이터 로드 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] newPokemons in
                guard let self = self else { return }
                
                if refresh {
                    self.pokemons = newPokemons
                } else {
                    let existingIds = Set(self.pokemons.map { $0.id })
                    let uniqueNewPokemons = newPokemons.filter { !existingIds.contains($0.id) }
                    self.pokemons.append(contentsOf: uniqueNewPokemons)
                }
                
                self.hasMoreData = newPokemons.count >= 20
            }
            .store(in: &cancellables)
    }
    
    func loadMoreIfNeeded() {
        if isLoading || isLoadingMore || !hasMoreData || isRequestInProgress { return }
        
        currentPage += 1
        loadData(refresh: false)
    }
    
    func resetSearch() {
        searchText = ""
        currentPage = 1
        loadData(refresh: true)
    }

    func toggleFavorite(for pokemonId: String) {
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
    
    private func setupSearchTextSubscription() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.handleSearchTextChanged()
            }
            .store(in: &cancellables)
    }

    private func handleSearchTextChanged() {
        currentPage = 1
        loadData(refresh: true)
    }
}
