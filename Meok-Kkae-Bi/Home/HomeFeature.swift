//
//  HomeFeature.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import ComposableArchitecture

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
        case menuCellTapped(OpenAIRecipe)
        case insertMenu(PresentationAction<InsertMenuFeature.Action>)
        case detailMenu(PresentationAction<DetailMenuFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            // 데이터 첫 로드
            case .onAppear:
                state.menus = [
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                    OpenAIRecipe(name: "test", category: "test", ingredients: [], totalCost: 10, steps: [], image: nil),
                ]
                return .none
                
            // GPT 버튼 클릭 이벤트
            case .gptButtonTapped:
                return .none
                
            // 레시피 추가 버튼 클릭 이벤트
            case .addButtonTapped:
                state.insertMenu = InsertMenuFeature.State()
                return .none
            // 레시피 추가 화면 닫기 이벤트
            case .insertMenu(.presented(.cancelButtonTapped)):
                state.insertMenu = nil
                return .none
            case .insertMenu:
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
