//
//  DetailMenuView.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import SwiftUI
import ComposableArchitecture

struct DetailMenuView: View {
    var store: StoreOf<DetailMenuFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text(viewStore.state.menu.name)
            Text("뒤로가기")
                .onTapGesture {
                    viewStore.send(.cancelButtonTapped)
                }
        }
    }
}

//#Preview {
//    DetailMenuView()
//}
