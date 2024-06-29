//
//  InsertMenuFeature.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import ComposableArchitecture

@Reducer
struct InsertMenuFeature {
    let recipeRetriever: OpenAIRecipeRetriever
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case cancelButtonTapped
        case requestRecipe
    }
    
    init() {
        self.recipeRetriever = OpenAIRecipeRetriever()
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestRecipe:
                Task {
                    let result = try await self.recipeRetriever.getRecipe(input: "스파게티 만드는 방법을 알려줘")
                }
                return .none
            default:
                return .none
            }
        }
    }
}
