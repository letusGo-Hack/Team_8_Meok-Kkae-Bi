//
//  TestData.swift
//  Meok-Kkae-Bi
//
//  Created by DY on 6/29/24.
//

struct TestData: Codable {
    var name: String
    var category: String
    var ingredients: [String]
    var totalCost: String
    var steps: [OpenAIRecipeStep]
    
    static func createMockData() -> Self {
        return .init(name: "테스트", category: "양식", ingredients: ["감자", "토마토", "베이컨", "스파게티"], totalCost: "약 20분", steps: [
            .init(ingredient: "감자", action: "삶기", timeCost: "1", fireLevel: "중불"),
            .init(ingredient: "토마토", action: "삶기", timeCost: "2", fireLevel: "중불"),
            .init(ingredient: "베이컨", action: "삶기", timeCost: "3", fireLevel: "중불"),
            .init(ingredient: "스파게티", action: "삶기", timeCost: "4", fireLevel: "중불"),
        ])
    }
}

