//
//  HomeView.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Perception.Bindable var store: StoreOf<HomeFeature>
    
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
