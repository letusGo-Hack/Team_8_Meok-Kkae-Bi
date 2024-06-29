//
//  HomeFeature.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct HomeFeature {
    
    @ObservableState
    struct State: Equatable {
        var menus: [OpenAIRecipe] = []
        @Presents var insertMenu: InsertMenuFeature.State?
        @Presents var detailMenu: DetailMenuFeature.State?
    }
    
    enum Action {
        case onAppear
        case gptButtonTapped
        case addButtonTapped
        case addRecipe(OpenAIRecipe)
        case failedToAddRecipe(String)
        case menuCellTapped(OpenAIRecipe)
        case insertMenu(PresentationAction<InsertMenuFeature.Action>)
        case detailMenu(PresentationAction<DetailMenuFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            // 데이터 첫 로드
            case .onAppear:
                if let saved = UserDefaults.standard.object(forKey: "menus") as? Data,
                    let savedRecipes = try? JSONDecoder().decode([OpenAIRecipe].self, from: saved) {
                    
                    state.menus = savedRecipes
                }
                
                return .none
            // GPT 버튼 클릭 이벤트
            case .gptButtonTapped:
                return .run { send in
                    let result = try await OpenAIRecipeRetriever().getRecipe(recipeName: "스파게티")
                    switch result {
                    case .success(let recipe):
                        await send(.addRecipe(recipe))
                    case .failure(let error):
                        await send(.failedToAddRecipe(String(describing: error)))
                    }
                }
                return .none
                
            // 레시피 추가 버튼 클릭 이벤트
            case .addButtonTapped:
                state.insertMenu = InsertMenuFeature.State()
                return .none
            // 레시피 추가 화면 닫기 이벤트
            case .insertMenu(.presented(.cancelButtonTapped)):
                state.insertMenu = nil
                return .none
            // 레시피 추가 화면 닫기 이벤트
            case let .insertMenu(.presented(.completeButtonTapped(recipe))):
                state.menus.append(recipe)
                state.insertMenu = nil
                return .none
//            case .insertMenu(.presented(.addRecipe(let recipe))):
//                let userDefaults = UserDefaults.standard
//                if let saved = userDefaults.object(forKey: "menus") as? Data,
//                    var savedRecipes = try? JSONDecoder().decode([OpenAIRecipe].self, from: saved) {
//                    
//                    savedRecipes.append(recipe)
//                    state.menus = savedRecipes
//                } else {
//                    state.menus = [recipe]
//                }
//                
//                if let encoded = try? JSONEncoder().encode(state.menus) {
//                    userDefaults.set(encoded, forKey: "menus")
//                }
//                
//                return .none
            case .insertMenu(.presented(.failedToAddRecipe(let errorMessage))):
                print(errorMessage)
                return .none
            // 레시피 보기 버튼 클릭 이벤트
            case let .menuCellTapped(menu):
                state.detailMenu = DetailMenuFeature.State(
                    menu: menu
                )
                return .none
            // 레시피 보기 화면 닫기 이벤트
            case .detailMenu(.presented(.cancelButtonTapped)):
                state.detailMenu = nil
                return .none
            case .detailMenu(_):
                return .none
            case .insertMenu(.dismiss):
                return .none
            case .insertMenu:
                return .none
            case .addRecipe(let recipe):
                let userDefaults = UserDefaults.standard
                if let saved = userDefaults.object(forKey: "menus") as? Data,
                    var savedRecipes = try? JSONDecoder().decode([OpenAIRecipe].self, from: saved) {

                    savedRecipes.append(recipe)
                    state.menus = savedRecipes
                } else {
                    state.menus = [recipe]
                }

                if let encoded = try? JSONEncoder().encode(state.menus) {
                    userDefaults.set(encoded, forKey: "menus")
                }

                return .none
            case .failedToAddRecipe(_):
                return .none
            }
        }
        .ifLet(\.$insertMenu, action: \.insertMenu) {
            InsertMenuFeature()
        }
        .ifLet(\.$detailMenu, action: \.detailMenu) {
            DetailMenuFeature()
        }
    }
}



