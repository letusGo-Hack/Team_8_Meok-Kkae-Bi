//
//  InsertMenuFeature.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import ComposableArchitecture

import Foundation

@Reducer
struct InsertMenuFeature {
    let recipeRetriever: OpenAIRecipeRetriever
    
    @ObservableState
    struct State: Equatable {
        let categories = ["한식", "양식", "중식", "일식"]
        
        var recipeName: String = ""
        var recipeIngredients: String = ""
        var selectedCategory: String = "한식"
        
        var steps: [OpenAIRecipeStep] = []
        
        var newStepTime: String = ""
        var newStepIngredient: String = ""
        var newStepDescription: String = ""
        
        var isValidToComplete: Bool = false
    }
    
    enum Action {
        case cancelButtonTapped
        case requestRecipe
        case setRecipeName(String)
        case setRecipeIngredients(String)
        case setCategory(String)
        
        case setNewStepTime(String)
        case setNewStepIngredient(String)
        case setNewStepDescription(String)
        
        case removeStep(Int)
        case addStep
        
        case checkIsValidToComplete
        
        case completeButtonTapped(OpenAIRecipe)
    }
    
    init() {
        self.recipeRetriever = OpenAIRecipeRetriever()
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestRecipe:
//                Task {
//                    let result = try await self.recipeRetriever.getRecipe(input: "스파게티 만드는 방법을 알려줘")
//                }
                return .none
                
            case .setRecipeName(let name):
                state.recipeName = name
                return .send(.checkIsValidToComplete)
                
            case .setRecipeIngredients(let ingredients):
                state.recipeIngredients = ingredients
                return .send(.checkIsValidToComplete)
                
            case .setCategory(let category):
                state.selectedCategory = category
                return .send(.checkIsValidToComplete)
            
            case .setNewStepTime(let time):
                state.newStepTime = time
                return .none
            
            case .setNewStepIngredient(let ingredient):
                state.newStepIngredient = ingredient
                return .none
            
            case .setNewStepDescription(let description):
                state.newStepDescription = description
                return .none
            
            case .removeStep(let index):
                state.steps.remove(at: index)
                return .send(.checkIsValidToComplete)
                
            case .addStep:
                let newStep = OpenAIRecipeStep(
                    ingredient: state.newStepIngredient,
                    action: state.newStepDescription,
                    timeCost: state.newStepTime,
                    fireLevel: nil
                )
                state.steps.append(newStep)
                return .send(.checkIsValidToComplete)
                
            case .checkIsValidToComplete:
                state.isValidToComplete = !state.recipeName.isEmpty
                    && !state.recipeIngredients.isEmpty
                    && !state.steps.isEmpty
                return .none
                
            default:
                return .none
            }
        }
    }
}
