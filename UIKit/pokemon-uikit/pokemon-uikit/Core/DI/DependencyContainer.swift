//
//  DependencyContainer.swift
//  Pokemon
//
//  Created by bokyung on 5/16/25.
//

import Foundation
import Swinject

class DependencyContainer {
    static let shared = DependencyContainer()
    
    let container = Container()
    
    private init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        // URL
        container.register(URL.self, name: "baseURL") { _ in
            return URL(string: "https://api.pokemontcg.io")!
        }
        
        // Service
        container.register(NetworkService.self) { _ in
            return NetworkServiceImp()
        }
        
        // Repository
        container.register(PokemonCardRepository.self) { resolver in
            let baseURL = resolver.resolve(URL.self, name: "baseURL")!
            let networkService = resolver.resolve(NetworkService.self)!
            return PokemonCardRepositoryImpl(baseURL: baseURL, networkService: networkService, context: CoredataController.shared.container.viewContext)
        }
        container.register(SupertypesRepository.self) { resolver in
            let baseURL = resolver.resolve(URL.self, name: "baseURL")!
            let networkService = resolver.resolve(NetworkService.self)!
            return SupertypesRepositoryImpl(baseURL: baseURL, networkService: networkService)
        }
        container.register(TypesRepository.self) { resolver in
            let baseURL = resolver.resolve(URL.self, name: "baseURL")!
            let networkService = resolver.resolve(NetworkService.self)!
            return TypesRepositoryImpl(baseURL: baseURL, networkService: networkService)
        }
        container.register(FavoritePokemonRepository.self) { resolver in
            let viewContext = CoredataController.shared.container.viewContext
            return FavoritePokemonRepositoryImpl(viewContext: viewContext)
        }
        
        // UseCase
        container.register(FetchPokemonUseCase.self) { resolver in
            let repository = resolver.resolve(PokemonCardRepository.self)!
            return FetchPokemonUseCaseImpl(repository: repository)
        }
        container.register(FetchSupertypesUseCase.self) { resolver in
            let repository = resolver.resolve(SupertypesRepository.self)!
            return FetchSupertypesUseCaseImpl(repository: repository)
        }
        container.register(FetchTypesUseCase.self) { resolver in
            let repository = resolver.resolve(TypesRepository.self)!
            return FetchTypesUseCaseImpl(repository: repository)
        }
        container.register(ToggleFavoriteFavoriteUseCase.self) { resolver in
            let repository = resolver.resolve(FavoritePokemonRepository.self)!
            return ToggleFavoriteFavoriteUseCaseImpl(repository: repository)
        }
        container.register(FetchFavoritePokemonUseCase.self) { resolver in
            let repository = resolver.resolve(FavoritePokemonRepository.self)!
            return FetchFavoritePokemonUseCaseImpl(repository: repository)
        }
        
        // ViewModel
        container.register(PokemonListViewModel.self) { resolver in
            let fetchPokemonUseCase = resolver.resolve(FetchPokemonUseCase.self)!
            let fetchSupertypesUseCase = resolver.resolve(FetchSupertypesUseCase.self)!
            let fetchTypesUseCase = resolver.resolve(FetchTypesUseCase.self)!
            let toggleFavoriteUseCase = resolver.resolve(ToggleFavoriteFavoriteUseCase.self)!
            let fetchFavoritePokemonUseCase = resolver.resolve(FetchFavoritePokemonUseCase.self)!
            return PokemonListViewModel(
                loadPokemonUseCase: fetchPokemonUseCase,
                fetchSupertypesUseCase: fetchSupertypesUseCase,
                fetchTypesUseCase: fetchTypesUseCase,
                toggleFavoriteUseCase: toggleFavoriteUseCase,
                fetchFavoritePokemonUseCase: fetchFavoritePokemonUseCase
                
            )
        }
    }
}
