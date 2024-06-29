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
                        Spacer().frame(width: 24)
                        
                        Text(viewStore.menu.name)
                            .font(.system(size: 30, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
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
                    
                    let foodType = CategoryType.create(value: viewStore.menu.category)
                    getImageLayer(image: foodType.image, superWidth: geometry.size.width)
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
                    
                    getRecipeListLayer(list: viewStore.menu)
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
                        .foregroundColor(._mainColor)
                        .cornerRadius(15)
                    }
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    private func getImageLayer(image: UIImage?, superWidth: CGFloat) -> some View {
        let imageExist: UIImage = (image == nil ? .imgCookNodata : image) ?? .imgCookNodata
        
        Image(uiImage: imageExist)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: superWidth - 38, height: superWidth - 38)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 10)
            )
            .padding()
    }
    
    @ViewBuilder
    private func getRecipeListLayer(list: OpenAIRecipe) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(list, id: \.self) { recipeStep in
                HStack {
                    let image = CookActionType.getCookActionType(value: recipeStep).image
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .clipped()
                    
                    Spacer()
                    
                    Text(recipeStep.timeCost)
                    
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
    
}

//#Preview {
//    DetailMenuView(store: Store(initialState: DetailMenuFeature.State(menu: OpenAIRecipe.stub)) {
//        DetailMenuFeature()
//    })
//}
