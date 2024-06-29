//
//  RecipeRetriever.swift
//  Meok-Kkae-Bi
//
//  Created by Minsoo Kim on 6/29/24.
//
import Foundation
import OpenAI
import SwiftData

@Model
class OpenAIRecipeStep: Codable {
    let ingredient: String?
    let action: String
    let timeCost: String?
    let fireLevel: String?
    
    enum CodingKeys: String, CodingKey {
        case ingredient
        case action
        case timeCost
        case fireLevel
    }
    
    init(ingredient: String?, action: String, timeCost: String?, fireLevel: String?) {
        self.ingredient = ingredient
        self.action = action
        self.timeCost = timeCost
        self.fireLevel = fireLevel
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ingredient = try values.decodeIfPresent(String.self, forKey: .ingredient)
        action = try values.decode(String.self, forKey: .action)
        timeCost = try values.decodeIfPresent(String.self, forKey: .timeCost)
        fireLevel = try values.decodeIfPresent(String.self, forKey: .fireLevel)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ingredient, forKey: .ingredient)
        try container.encode(action, forKey: .action)
        try container.encode(timeCost, forKey: .action)
        try container.encode(fireLevel, forKey: .action)
    }
}

@Model
class OpenAIRecipe: Codable {
    var name: String
    var category: String
    var ingredients: [String]
    var totalCost: String
    var steps: [String:[OpenAIRecipeStep]]
    
    enum CodingKeys: String, CodingKey {
        case name
        case category
        case ingredients
        case totalCost
        case steps
    }
    
    init(name: String, category: String, ingredients: [String], totalCost: String, steps: [String : [OpenAIRecipeStep]]) {
        self.name = name
        self.category = category
        self.ingredients = ingredients
        self.totalCost = totalCost
        self.steps = steps
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        category = try values.decode(String.self, forKey: .category)
        ingredients = try values.decode([String].self, forKey: .ingredients)
        totalCost = try values.decode(String.self, forKey: .totalCost)
        steps = try values.decode([String:[OpenAIRecipeStep]].self, forKey: .steps)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(totalCost, forKey: .totalCost)
        try container.encode(ingredients, forKey: .ingredients)

        try container.encode(steps, forKey: .steps)
    }
    
}

extension OpenAIRecipe {
    static var stub: OpenAIRecipe {
        return try! JSONDecoder().decode(OpenAIRecipe.self, from: Data("""
        {\n    \"name\": \"스파게티\",\n    \"totalCost\": \"약 25분\",\n    \"category\": \"양식\",\n    \"ingredients\": [\"스파게티면🍝\", \"물💧\", \"올리브오일🫒\", \"소금🧂\", \"마늘🧄\", \"양파🧅\", \"토마토소스🍅\", \"소고기 간 것🥩\", \"파마산치즈🧀\", \"후추가루\"],\n    \"steps\": {\n        \"스파게티면_삶기\": [\n            {\"action\": \"재료 넣기\", \"ingredient\": \"물💧\"},\n            {\"action\": \"끓이기\", \"timeCost\": \"7분\", \"fireLevel\": \"강불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"소금🧂\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"스파게티면🍝\"},\n            {\"action\": \"끓이기\", \"timeCost\": \"10분\", \"fireLevel\": \"강불\"},\n            {\"action\": \"불 끄기\"},\n            {\"action\": \"면 건지기\"}\n        ],\n        \"재료_준비하기\": [\n            {\"action\": \"재료 다지기\", \"ingredient\": \"마늘🧄\"},\n            {\"action\": \"재료 다지기\", \"ingredient\": \"양파🧅\"}\n        ],\n        \"소스_만들기\": [\n            {\"action\": \"재료 넣기\", \"ingredient\": \"올리브오일🫒\", \"fireLevel\": \"중불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"마늘🧄\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"양파🧅\"},\n            {\"action\": \"볶기\", \"timeCost\": \"5분\", \"fireLevel\": \"중불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"소고기 간 것🥩\"},\n            {\"action\": \"볶기\", \"timeCost\": \"5분\", \"fireLevel\": \"중불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"토마토소스🍅\"},\n            {\"action\": \"끓이기\", \"timeCost\": \"5분\", \"fireLevel\": \"중불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"후추가루\"}\n        ],\n        \"면과_소스_합치기\": [\n            {\"action\": \"재료 넣기\", \"ingredient\": \"삶은 스파게티면🍝\"},\n            {\"action\": \"섞기\", \"timeCost\": \"2분\"},\n            {\"action\": \"불 끄기\"}\n        ],\n        \"마무리\": [\n            {\"action\": \"재료 넣기\", \"ingredient\": \"파마산치즈🧀\", \"quantity\": \"적당히\"},\n            {\"action\": \"서빙하기\"}\n        ]\n    }\n}
        """.utf8))
    }
    
}

class OpenAIRecipeRetriever: NSObject, URLSessionDelegate {
    var openAI: OpenAI? = nil
    
    let defaultPrompt: String = """
    너는 모든 요리에 대해 조리 순서를 성실하게 알려줄 수 있는 Hackathon Cooker야.

    주어진 질문에 대한 음식을 만들 수 있는 방법을 한 단계 한 단계 설명해줘야 해.

    답변의 형태는 요리의 이름(name), 요리의 예상 소요 시간과(timeCost), 요리의 모든 재료(ingredients), 그리고 요리를 완성 시키기 위해 순서가 정해져 있는 조리 방법들의 집합이야.

    요리를 위한 조리 방법은 ["볶기","찌기","굽기","데치기","기다리기", "재료 넣기", "불 끄기"] 등이 있을 수 있어, 조리 방법 뒤엔 재료와 양(quantity)이나 시간(time cost)가 포함되어있을 수 있고 "|"로 구분 해야 해.
    
    조리방법은 action, ingredient, timecost 그리고 firelevel로 구성되고, action이 조리 행동이라면 소요시간과 불의 세기가 중요하다면 불의 세기도 표시가 되어야 해. 재료를 넣어야 하는 동작이라면 재료의 이름이 표시가 되어야 해

    요리단계에서 요리재료는 이모티콘(Unicode imoticon)으로 표현이 가능하면 이모티콘(Unicode imoticon)으로 줘야해.

    요리의 종류는 category 로 표현되어야 하고, 한식, 양식, 중식, 일식 등이 있어.
    [/INST]
    [EXAMPLE]:
    {
        "name": "까르보나라 파스타",
        "totalCost": "약 15분",
        "category": "양식"
        "ingredients": ["파스타면", "물","파마산치즈 가루","양파","마늘","후추가루","올리브오일","소금", "베이컨","계란혼합물"]
        "steps": {
           "파스타면_삶기": [{"action:"재료 넣기", "ingredient":"물"}, {"action:"끓이기", "timeCost":"5분", "fireLevel":"강불"}, {"action:"재료넣기", "ingredient":"파스타면"}, {"action":"끓이기", "timeCost":"10분"}, {"action":"불끄기"}, {"action":"면 건지기"}],
           "🧅와_🥓_볶기": [{"action:"재료 넣기", "ingredient":"🫒오일", "fireLevel":"중불"}, {"action":"재료넣기", "ingredient": "🧅"}, {"action": "재료 넣기", "ingredient":"🥓"},{"action": "재료 넣기", "ingredient":"후춧가루"},{"action": "볶기", "timeCost":"3분", "fireLevel":"중불"}, {"action": "재료넣기", "timeCost":"면수"}, {"action": "볶기", "timeCost":"1분", "fireLevel":"중불"},{"action": "불끄기"},{"action": "🥚혼합물"}]
         }
    }
    """

    
    override init() {
        let openAiApiKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_AI_API_KEY") as? String
        
        super.init()
        
        if let openAiApiKey = openAiApiKey {
            self.openAI = OpenAI(apiToken: openAiApiKey)
        }
    }
    
    func getRecipe(recipeName: String) async throws -> OpenAIRecipe {
        
        return OpenAIRecipe.stub
        
        let chatQuery = ChatQuery(messages: [.system(.init(content: self.defaultPrompt, name: "assistant")), .user(.init(content: .string("\(recipeName) 만드는 방법 알려줘")))], model: .gpt4_o)
//
        do {
            guard let openAI = self.openAI else {
                throw NSError(domain: "openAI 초기화 실패", code: 400)
            }
            let completionResult = try await openAI.chats(query: chatQuery)
            let firstQuestion = completionResult.choices.first?.message.content?.string
            
            
            guard let firstQuestion = firstQuestion else { print("정상적이지 못한 답변.\(String(describing: completionResult))"); throw NSError(domain: "OpenAI: 정상적이지 못한 답변", code: 500, userInfo: ["message": completionResult]) }
            
            let recipe: OpenAIRecipe = try JSONDecoder().decode(OpenAIRecipe.self,from: Data(firstQuestion.utf8))
            
            print(firstQuestion)
            
            return recipe
        } catch {
            print("OpenAPI Error \(error)")
            throw error
        }
    }
    
}
