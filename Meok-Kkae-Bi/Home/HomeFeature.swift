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
        var menus: [String] = ["1","2","3"] // TODO: 데이터 모델 정해지면 바꾸기
        
        @Presents var insertMenu: InsertMenuFeature.State?
        @Presents var detailMenu: DetailMenuFeature.State?
    }
    
    enum Action {
        case onAppear
        case addButtonTapped
        case menuCellTapped(String)
        case insertMenu(PresentationAction<InsertMenuFeature.Action>)
        case detailMenu(PresentationAction<DetailMenuFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            // 데이터 첫 로드
            case .onAppear:
                // TODO: 처음에 데이터 로딩하는 코드 추가 SwiftData
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
