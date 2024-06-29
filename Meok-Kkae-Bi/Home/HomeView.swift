//
//  HomeView.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .top) {
                 
                Rectangle()
                    .fill(Color._mainColor)
                    .frame(height: 200)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("레시피 목록")
                            .foregroundColor(Color.white)
                            .font(.system(size: 30, weight: .bold))
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                        
                        Spacer()
                        Button {
                            store.send(.gptButtonTapped)
                        } label: {
                            Image(systemName: "airtag")
                        }
                        
                        Button {
                            store.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(0..<(viewStore.state.menus.count), id: \.self) { idx in
                                let menu = viewStore.state.menus[idx]
                                MenuCell(menu: menu)
                                    .onTapGesture {
                                        viewStore.send(.menuCellTapped(menu))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            }
                        }

                    }
                }
                
//                Text("추가하기")
//                    .onTapGesture {
//                        viewStore.send(.addButtonTapped)
//                    }
            }
            .task {
                store.send(.onAppear)
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

#Preview {
    HomeView(store:
        Store(
            initialState: HomeFeature.State(
                menus: [
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                ]
            )
        ) {
            HomeFeature()
        }
    )
}
