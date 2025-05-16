//
//  PokemonApp.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import SwiftUI

@main
struct PokemonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PokemonListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
