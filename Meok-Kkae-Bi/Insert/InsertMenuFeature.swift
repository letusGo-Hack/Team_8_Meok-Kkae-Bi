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
        case addRecipe(recipe: OpenAIRecipe)
        case failedToAddRecipe(errorString: String)
    }
    
    init() {
        self.recipeRetriever = OpenAIRecipeRetriever()
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestRecipe:
                return .run { send in
                    let result = try await self.recipeRetriever.getRecipe(recipeName: "스파게티")
                    switch result {
                    case .success(let recipe):
                        await send(.addRecipe(recipe: recipe))
                    case .failure(let error):
                        await send(.failedToAddRecipe(errorString: String(describing: error)))
                    }
                }
            default:
                return .none
            }
        }
    }
}
