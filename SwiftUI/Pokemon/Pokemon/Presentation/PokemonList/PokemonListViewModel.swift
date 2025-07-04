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
    private let fetchFavoritePokemonUseCase: FetchFavoritePokemonUseCase

    private var currentPage = 1
    private var isRequestInProgress = false
    
    var filteredPokemons: [Pokemon] {
        return pokemons
            .filter(favoriteFilter)
            .filter(superTypeFilter)
            .filter(typesFilter)
    }

    init(
        loadPokemonUseCase: FetchPokemonUseCase,
        fetchSupertypesUseCase: FetchSupertypesUseCase,
        fetchTypesUseCase: FetchTypesUseCase,
        toggleFavoriteUseCase: ToggleFavoriteFavoriteUseCase,
        fetchFavoritePokemonUseCase: FetchFavoritePokemonUseCase
    ) {
        self.loadPokemonUseCase = loadPokemonUseCase
        self.fetchSupertypesUseCase = fetchSupertypesUseCase
        self.fetchTypesUseCase = fetchTypesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.fetchFavoritePokemonUseCase = fetchFavoritePokemonUseCase
        subscribeFilters()
        loadSuperTypes()
        loadTypes()
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
    
    // Coredata의 즐겨찾기 포켓몬 로드
    func loadFavoritePokemons() {
        isLoading = true
        errorMessage = nil

        fetchFavoritePokemonUseCase.execute()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false
            if case let .failure(error) = completion {
                self.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] favoritePokemons in
            self?.pokemons = favoritePokemons
            self?.hasMoreData = false
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
                    self?.pokemons[index].isFavorite = updatedIsFavorite
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
        selectedSuperType = (selectedSuperType == type) ? nil : type
        currentPage = 1
    }
    
    // 타입 선택
    func toggleTypeSelection(_ type: String) {
        selectedTypes.formSymmetricDifference([type])
        currentPage = 1
    }
    
    // 필터 초기화
    func resetFilters() {
        selectedSuperType = nil
        selectedTypes.removeAll()
        currentPage = 1
        isShowFavoritesOnly = false
    }

    // 필터 구독
    private func subscribeFilters() {
        Publishers.CombineLatest4(
            $searchText
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .removeDuplicates(),
            $selectedSuperType.removeDuplicates(),
            $selectedTypes.removeDuplicates(),
            $isShowFavoritesOnly.removeDuplicates()
        )
        .map { [weak self] searchText, superType, types, showFavorites -> AnyPublisher<[Pokemon], Never> in
            print("Filters:", searchText, superType ?? "nil", types, showFavorites)
            self?.isLoading = true
            guard let self = self else {
                return Just([]).eraseToAnyPublisher()
            }

            self.currentPage = 1
            self.errorMessage = nil

            if showFavorites {
                return self.fetchFavoritePokemonUseCase.execute()
                    .map { favoritePokemons in
                        return favoritePokemons.filter { pokemon in
                            let matchesSearch = searchText.isEmpty || pokemon.name.localizedCaseInsensitiveContains(searchText)
                            let matchesSuperType = (superType == nil) || pokemon.supertype.contains(superType!)
                            let matchesTypes = types.isEmpty || (pokemon.types?.contains(where: { types.contains($0) }) ?? false)
                            return matchesSearch && matchesSuperType && matchesTypes
                        }
                    }
                    .receive(on: DispatchQueue.main)
                    .catch { error -> Just<[Pokemon]> in
                        self.errorMessage = error.localizedDescription
                        return Just([])
                    }
                    .eraseToAnyPublisher()
            } else {
                return self.loadPokemonUseCase.execute(
                    page: self.currentPage,
                    searchText: searchText.isEmpty ? nil : searchText,
                    selectedSuperType: superType,
                    selectedTypes: types
                )
                .receive(on: DispatchQueue.main)
                .catch { error -> Just<[Pokemon]> in
                    self.errorMessage = error.localizedDescription
                    return Just([])
                }
                .eraseToAnyPublisher()
            }
        }
        .switchToLatest()
        .sink { [weak self] newPokemons in
            self?.pokemons = newPokemons
            self?.hasMoreData = newPokemons.count >= 20
            self?.isLoading = false
        }
        .store(in: &cancellables)
    }

    private func handleSearchTextChanged() {
        currentPage = 1
        loadPokemons(refresh: true)
    }
    
    // 필터
    private func favoriteFilter(_ pokemon: Pokemon) -> Bool {
        return !isShowFavoritesOnly || pokemon.isFavorite
    }
    
    private func superTypeFilter(_ pokemon: Pokemon) -> Bool {
        guard let selectedSuperType = selectedSuperType else { return true }
        return pokemon.supertype.contains(selectedSuperType)
    }
    
    private func typesFilter(_ pokemon: Pokemon) -> Bool {
        if selectedTypes.isEmpty { return true }
        guard let pokemonTypes = pokemon.types else { return false }
        return !selectedTypes.isDisjoint(with: Set(pokemonTypes))
    }
}
