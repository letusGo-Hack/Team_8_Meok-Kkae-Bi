//
//  Meok_Kkae_BiApp.swift
//  Meok-Kkae-Bi
//
//  Created by 고병학 on 6/29/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct MeokKkaeBiApp: App {
    
    var body: some Scene {
        WindowGroup {
            HomeView(
                store: Store(initialState: HomeFeature.State()) {
                    HomeFeature()
                        ._printChanges()
                }
            )
        }
    }
}
