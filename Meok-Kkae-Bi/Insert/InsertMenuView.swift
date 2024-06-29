//
//  InsertMenuView.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import SwiftUI
import ComposableArchitecture

struct InsertMenuView: View {
    var store: StoreOf<InsertMenuFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("뒤로가기")
                .onTapGesture {
                    viewStore.send(.cancelButtonTapped)
                }
            Text("메뉴요청하기")
                .onTapGesture {
                    viewStore.send(.requestRecipe)
                }
        }
    }
}

//#Preview {
//    InsertMenuView()
//}
