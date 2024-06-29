//
//  InsertMenuView.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import SwiftUI
import ComposableArchitecture

struct InsertMenuView: View {
    var store: StoreOf<InsertMenuFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("레시피 추가")
                            .font(.title)
                            .bold()
                        Spacer()
                        Button(action: {
                            // Close action
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.orange)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Group {
                            Text("이름")
                                .font(.headline)
                            TextField("레시피 이름을 입력하세요.", text: $recipeName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)
                        
                        Group {
                            Text("재료")
                                .font(.headline)
                            TextField("레시피 재료를 입력하세요.", text: $recipeIngredients)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)
                        
                        Group {
                            Text("분류")
                                .font(.headline)
                            Picker("분류", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        .padding(.horizontal)
                        
                        Text("단계")
                            .font(.headline)
                            .padding(.horizontal)
                        
                            ForEach(steps) { step in
                                HStack {
                                    Text(step.time)
                                    Spacer()
                                    Text(step.ingredients + " " + step.description)
                                    Spacer()
                                    Button(action: {
                                        if let index = steps.firstIndex(where: { $0.id == step.id }) {
                                            steps.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .onDelete { indices in
                                steps.remove(atOffsets: indices)
                            }
                        
                        HStack {
                            TextField("시간", text: $newStepTime)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("재료", text: $newStepIngredients)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("행동", text: $newStepDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                if !newStepDescription.isEmpty {
                                    steps.append(RecipeStep(
                                        time: newStepTime,
                                        ingredients: newStepIngredients,
                                        description: newStepDescription
                                    ))
                                    newStepTime = ""
                                    newStepIngredients = ""
                                    newStepDescription = ""
                                }
                            }) {
                                Text("추가")
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    Button(action: {
                        // 완료 버튼 액션
                    }) {
                        Text("완료")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
                .background(Color(UIColor.systemBackground))
            }
            .animation(.easeInOut, value: self.steps)
        }
    }
}

//#Preview {
//    InsertMenuView()
//}
