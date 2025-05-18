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
    @Published var superTypes: [String] = []
    @Published var types: [String] = []
    @Published var selectedSuperType: String? = nil
    @Published var selectedTypes: Set<String> = []
    
    private var cancellables = Set<AnyCancellable>()
    private let loadPokemonUseCase: FetchPokemonUseCase
    private let fetchSupertypesUseCase: FetchSupertypesUseCase
    private let fetchTypesUseCase: FetchTypesUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteFavoriteUseCase

    private var currentPage = 1
    private var isRequestInProgress = false
    
    var filteredPokemons: [Pokemon] {
        var list = pokemons
        if isShowFavoritesOnly {
            list = list.filter { $0.isFavorite }
        }
        return list
    }
    
    init(
        loadPokemonUseCase: FetchPokemonUseCase,
        fetchSupertypesUseCase: FetchSupertypesUseCase,
        fetchTypesUseCase: FetchTypesUseCase,
        toggleFavoriteUseCase: ToggleFavoriteFavoriteUseCase
    ) {
        self.loadPokemonUseCase = loadPokemonUseCase
        self.fetchSupertypesUseCase = fetchSupertypesUseCase
        self.fetchTypesUseCase = fetchTypesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        subscribeSearchText()
        subscribeFilters()
        loadSuperTypes()
        loadTypes()
        loadPokemons()
    }
    
    func loadSuperTypes() {
        fetchSupertypesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Failed to load supertypes: \(error)")
                }
            } receiveValue: { [weak self] superTypes in
                self?.superTypes = superTypes
            }
            .store(in: &cancellables)
    }
    
    func loadTypes() {
        fetchTypesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Failed to load types: \(error)")
                }
            } receiveValue: { [weak self] types in
                self?.types = types
            }
            .store(in: &cancellables)
    }
    
    // 포켓몬 데이터
    func loadPokemons(refresh: Bool = true) {
        if isRequestInProgress { return }
        
        if refresh {
            isLoading = true
            currentPage = 1
            errorMessage = nil
        } else {
            isLoadingMore = true
        }

        isRequestInProgress = true

        loadPokemonUseCase.execute(
            page: currentPage,
            searchText: searchText.isEmpty ? nil : searchText,
            selectedSuperType: selectedSuperType,
            selectedTypes: selectedTypes
        )
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
        loadPokemons(refresh: false)
    }
    
    // 즐겨찾기 추가/해제
    func toggleFavorite(for pokemonId: String) {
        if let index = pokemons.firstIndex(where: { $0.id == pokemonId }) {
            let pokemon = pokemons[index]
            toggleFavoriteUseCase.execute(pokemon: pokemon)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("즐겨찾기 실패: \(error)")
                    }
                } receiveValue: { [weak self] updatedIsFavorite in
                    self?.pokemons[index] = Pokemon(
                        id: pokemon.id,
                        name: pokemon.name,
                        supertype: pokemon.supertype,
                        types: pokemon.types,
                        imageURL: pokemon.imageURL,
                        logoImage: pokemon.logoImage,
                        isFavorite: updatedIsFavorite
                    )
                    print("즐겨찾기 추가/해제 성공: \(updatedIsFavorite)")
                }
                .store(in: &cancellables)
        }
    }
    
    // 검색 초기화
    func resetSearch() {
        searchText = ""
        currentPage = 1
        loadPokemons(refresh: true)
    }
    
    // 슈퍼타입 선택
    func handleSuperTypeSelection(_ type: String) {
        selectedTypes.removeAll()
        if selectedSuperType == type {
            selectedSuperType = nil
        } else {
            selectedSuperType = type
        }
        currentPage = 1
        loadPokemons(refresh: true)
    }
    
    // 타입 선택
    func toggleTypeSelection(_ type: String) {
        selectedTypes.formSymmetricDifference([type])
        currentPage = 1
        loadPokemons(refresh: true)
    }
    
    // 필터 초기화
    func resetFilters() {
        selectedSuperType = nil
        selectedTypes.removeAll()
        currentPage = 1
        isShowFavoritesOnly = false
        loadPokemons(refresh: true)
    }
    
    // 검색
    private func subscribeSearchText() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] text -> AnyPublisher<[Pokemon], Never> in
                guard let self = self else {
                    return Just([]).eraseToAnyPublisher()
                }

                self.isLoading = true
                self.errorMessage = nil
                self.currentPage = 1

                return self.loadPokemonUseCase.execute(
                    page: self.currentPage,
                    searchText: text.isEmpty ? nil : text,
                    selectedSuperType: self.selectedSuperType,
                    selectedTypes: self.selectedTypes
                )
                .catch { error -> Just<[Pokemon]> in
                    self.errorMessage = error.localizedDescription
                    return Just([])
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [weak self] newPokemons in
                guard let self = self else { return }
                self.pokemons = newPokemons
                self.hasMoreData = newPokemons.count >= 20
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    // 필터 (슈퍼 타입 + 타입)
    private func subscribeFilters() {
        Publishers.CombineLatest($selectedSuperType, $selectedTypes)
            .removeDuplicates { lhs, rhs in
                lhs.0 == rhs.0 && lhs.1 == rhs.1
            }
            .map { [weak self] superType, types -> AnyPublisher<[Pokemon], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                
                self.isLoading = true
                self.errorMessage = nil
                self.currentPage = 1
                
                return self.loadPokemonUseCase.execute(
                    page: self.currentPage,
                    searchText: self.searchText.isEmpty ? nil : self.searchText,
                    selectedSuperType: superType,
                    selectedTypes: types
                )
                .catch { error -> Just<[Pokemon]> in
                    self.errorMessage = error.localizedDescription
                    return Just([])
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [weak self] newPokemons in
                guard let self = self else { return }
                
                self.pokemons = newPokemons
                self.hasMoreData = newPokemons.count >= 20
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func handleSearchTextChanged() {
        currentPage = 1
        loadPokemons(refresh: true)
    }
}
