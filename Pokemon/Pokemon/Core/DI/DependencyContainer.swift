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
            return PokemonCardRepositoryImp(baseURL: baseURL, networkService: networkService)
        }
        
        // UseCase
        container.register(LoadPokemonUseCase.self) { resolver in
            let repository = resolver.resolve(PokemonCardRepository.self)!
            return LoadPokemonUseCaseImp(repository: repository)
        }
        
        // ViewModel
        container.register(PokemonListViewModel.self) { resolver in
            let useCase = resolver.resolve(LoadPokemonUseCase.self)!
            return PokemonListViewModel(
                loadPokemonUseCase: useCase
            )
        }
    }
}
