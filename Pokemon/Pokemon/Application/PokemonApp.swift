//
//  PokemonApp.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import SwiftUI

@main
struct PokemonApp: App {
    let persistenceController = CoredataController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                PokemonListView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
