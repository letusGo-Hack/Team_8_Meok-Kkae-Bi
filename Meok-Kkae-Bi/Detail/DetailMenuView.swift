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
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Text(viewStore.state.menu)
                        Spacer()
                        Button(action: {
                            viewStore.send(.cancelButtonTapped)
                        }) {
                            Image(uiImage: .imgCancel)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                    
                    Spacer().frame(height: 30)
                    
                    Image(uiImage: viewStore.state.menuImage ?? .imgCookNodata)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width - 38, height: geometry.size.width - 38)
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 10)
                        )
                        .padding()
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("소스 준비")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom, 8)
                    
                    Text("Steps")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewStore.steps, id: \.self) { recipeStep in
                            HStack {
                                let image = CookActionType.getCookActionType(value: recipeStep.action).image
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .clipped()
                                
                                Spacer()
                                
                                Text(viewStore.timeCost)
                                
                                Spacer()
                                
                                Text(recipeStep.ingredient ?? "재료 없음" + recipeStep.action)
                                    .padding(.vertical, 4)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Color(#colorLiteral(red: 1.0, green: 0.89, blue: 0.74, alpha: 1.0)))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        Button(action: {
                            viewStore.send(.startButtonTapped)
                        }) {
                            Text("시작하기!")
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .background(._mainColor)
                        .cornerRadius(15)
                    }
                }
                .padding()
                
            }
        }
    }
}

//#Preview {
//    DetailMenuView(store: )
//}
