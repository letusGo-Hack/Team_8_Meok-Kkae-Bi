//
//  DetailMenuFeature.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import ComposableArchitecture

@Reducer
struct DetailMenuFeature {
    
    @ObservableState
    struct State: Equatable {
        var menu: String
    }
    
    enum Action {
        case cancelButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
