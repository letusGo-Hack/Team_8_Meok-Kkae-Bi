//
//  HomeView.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import ComposableArchitecture

import ActivityKit
import SwiftUI
import WidgetKit

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                List {
                    Section(
                        content: {
                            VStack {
                                ForEach(viewStore.state.menus, id: \.self) { menu in
                                    Text(menu)
                                        .onTapGesture {
                                            viewStore.send(.menuCellTapped(menu))
                                        }
                                }
                            }
                        }
                    )
                }
                
                Button(
                    action: {
                        let attributes = MeokWidgetAttributes(name: "MUK")
                        let contentState = MeokWidgetAttributes.ContentState(emoji: "🚧")
                        
                        do {
                            let activity = try Activity<MeokWidgetAttributes>.request(
                                attributes: attributes,
                                contentState: contentState
                            )
                        print(activity)
                    }
                    catch {
                        print(error)
                    }
                }) {
                    Text("DynamicIsland!")
                }
                
                Text("추가하기")
                    .onTapGesture {
                        viewStore.send(.addButtonTapped)
                    }
            }
            .fullScreenCover(
                item: $store.scope(state: \.insertMenu, action: \.insertMenu)
            ) { insertMenuStore in
                NavigationStack {
                    InsertMenuView(store: insertMenuStore)
                }
            }
            .fullScreenCover(
                item: $store.scope(state: \.detailMenu, action: \.detailMenu)
            ) { detailMenuStore in
                NavigationStack {
                    DetailMenuView(store: detailMenuStore)
                }
            }
        }
    }
}

//#Preview {
//    HomeView()
//}
