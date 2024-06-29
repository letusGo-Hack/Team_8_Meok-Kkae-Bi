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
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        ForEach(viewStore.state.steps, id: \.self) { step in
                            HStack {
                                Image(systemName: "pot.fill")
                                Text("- 올리브 오일 넣기")
                            }
                            Text(step)
                                .padding(.vertical, 4)
                        }
                        HStack {
                            Image(systemName: "pot.fill")
                            Text("- 올리브 오일 넣기")
                            
                        }
                        
                        HStack {
                            Image(systemName: "pot.fill")
                            Text("- 다진 마늘 넣기")
                        }
                        
                        HStack {
                            Image(systemName: "flame.fill")
                            Text("1분 중불 볶기")
                        }
                        
                        HStack {
                            Image(systemName: "pot.fill")
                            Text("- 다진 양파 넣기")
                        }
                        
                        HStack {
                            Image(systemName: "flame.fill")
                            Text("9분 중불 볶기")
                        }
                        
                        HStack {
                            Image(systemName: "bell.fill")
                            Text("- 불 끄기")
                        }
                    }
                    .padding()
                    .background(Color(#colorLiteral(red: 1.0, green: 0.89, blue: 0.74, alpha: 1.0)))
                    .cornerRadius(10)
                }
                .padding()
                
            }
        }
    }
}

//#Preview {
//    DetailMenuView(store: )
//}
