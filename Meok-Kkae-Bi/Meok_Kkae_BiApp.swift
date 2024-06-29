//
//  Meok_Kkae_BiApp.swift
//  Meok-Kkae-Bi
//
//  Created by 고병학 on 6/29/24.
//

import SwiftUI
import SwiftData

@main
struct Meok_Kkae_BiApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
