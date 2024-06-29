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
                            viewStore.send(.cancelButtonTapped)
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
                            TextField("레시피 이름을 입력하세요.", text: viewStore.binding(
                                get: \.recipeName,
                                send: { InsertMenuFeature.Action.setRecipeName($0) }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)
                        
                        Group {
                            Text("재료")
                                .font(.headline)
                            TextField("레시피 재료를 입력하세요. (띄어쓰기로 구분해주세요)", text: viewStore.binding(
                                get: \.recipeIngredients,
                                send: { InsertMenuFeature.Action.setRecipeIngredients($0) }
                            ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)
                        
                        Group {
                            Text("분류")
                                .font(.headline)
                            Picker("분류", selection: viewStore.binding(
                                get: \.selectedCategory,
                                send: { InsertMenuFeature.Action.setCategory($0) }
                            )) {
                                ForEach(viewStore.categories, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        .padding(.horizontal)
                        
                        Text("단계")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(viewStore.steps, id: \.self) { (step: OpenAIRecipeStep) in
                            HStack {
                                Text(buildTimeString(step.timeCost))
                                Spacer()
                                Text((step.ingredient ?? "") + " " + step.action)
                                Spacer()
                                Button(action: {
                                    if let index = viewStore.steps.firstIndex(where: { $0 == step }) {
                                        viewStore.send(.removeStep(index))
                                        HapticManager.instance.generateHaptic()
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        HStack {
                            TextField("시간(초)", text: viewStore.binding(
                                get: \.newStepTime,
                                send: InsertMenuFeature.Action.setNewStepTime
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("재료", text: viewStore.binding(
                                get: \.newStepIngredient,
                                send: InsertMenuFeature.Action.setNewStepIngredient
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("행동", text: viewStore.binding(
                                get: \.newStepDescription,
                                send: InsertMenuFeature.Action.setNewStepDescription
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                if !viewStore.newStepDescription.isEmpty {
                                    viewStore.send(.addStep)
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
                        guard viewStore.isValidToComplete else { return }
                        let recipe = buildRecipe(viewStore.state)
                        viewStore.send(.completeButtonTapped(recipe))
                    }) {
                        Text("완료")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewStore.isValidToComplete ? Color.orange : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
                .background(Color(UIColor.systemBackground))
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
    
    private func buildTimeString(_ string: String?) -> String {
        guard let string = string,
              let seconds: Int = Int(string) else {
            return ""
        }
        let minutes: Int = Int(seconds / 60)
        let remainingSeconds: Int = seconds % 60
        
        if minutes > 0 {
            return "\(minutes)분 \(remainingSeconds)초"
        } else {
            return "\(remainingSeconds)초"
        }
    }
    
    private func buildRecipe(_ state: InsertMenuFeature.State) -> OpenAIRecipe {
        let totalCost: Int = state.steps.reduce(0) {
            $0 + (Int($1.timeCost ?? "") ?? 0)
        }
        return .init(
            name: state.recipeName,
            category: state.selectedCategory,
            ingredients: state.recipeIngredients.components(separatedBy: " "),
            totalCost: "\(totalCost)",
            steps: ["0": state.steps]
        )
    }
}

//#Preview {
//    InsertMenuView()
//}
