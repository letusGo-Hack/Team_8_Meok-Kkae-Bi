//
//  DetailMenuFeature.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct DetailMenuFeature {
    
    @ObservableState
    struct State: Equatable {
        var boxSize: CGFloat
        var menu: OpenAIRecipe
    }
    
    enum Action {
        /// 취소 버튼
        case cancelButtonTapped
        /// 시작 버튼
        case startButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .none
            default:
                // TODO: 레시피 시작
                return .none
            }
        }
    }
}
