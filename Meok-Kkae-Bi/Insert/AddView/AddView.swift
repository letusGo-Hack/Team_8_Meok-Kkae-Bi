//
//  AddView.swift
//  Meok-Kkae-Bi
//
//  Created by 고병학 on 6/29/24.
//

import SwiftUI

struct RecipeStep: Identifiable, Hashable {
    let id = UUID()
    var time: String
    var ingredients: String
    var description: String
}

struct RecipeAddView: View {
    @State private var recipeName: String = ""
    @State private var recipeIngredients: String = ""
    @State private var selectedCategory: String = "한식"
    @State private var steps: [RecipeStep] = [
        RecipeStep(time: "5분", ingredients: "물 500ml", description: "끓이기"),
        RecipeStep(time: "10분", ingredients: "면 200g", description: "삶기"),
        RecipeStep(time: "3분", ingredients: "양파 1개", description: "자르기"),
        RecipeStep(time: "5분", ingredients: "당근 1개", description: "자르기"),
        RecipeStep(time: "7분", ingredients: "고기 300g", description: "볶기"),
        RecipeStep(time: "2분", ingredients: "마늘 3쪽", description: "다지기"),
        RecipeStep(time: "8분", ingredients: "소스 100ml", description: "준비하기"),
        RecipeStep(time: "4분", ingredients: "버섯 200g", description: "자르기"),
        RecipeStep(time: "6분", ingredients: "파 1대", description: "자르기" ),
        RecipeStep(time: "5분", ingredients: "고추 2개", description: "자르기"),
        RecipeStep(time: "10분", ingredients: "감자 2개", description: "삶기")
    ]
    @State private var newStepTime: String = ""
    @State private var newStepIngredients: String = ""
    @State private var newStepDescription: String = ""
    
    var categories = ["한식", "양식", "중식", "일식"]
    
    var body: some View {
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

struct RecipeAddView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeAddView()
    }
}
