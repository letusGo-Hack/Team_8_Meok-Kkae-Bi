//
//  RecipeRetriever.swift
//  Meok-Kkae-Bi
//
//  Created by Minsoo Kim on 6/29/24.
//
import Foundation
import OpenAI

enum OpenAIV1EndPoint {
    case chatCompletion
    
    var endpoint: String {
        switch self {
        case .chatCompletion:
            return "v1/chat/completions"
        }
    }
}

enum OpenAIAssistant {
    case hackathon
    
    var identifier: String {
        switch self {
        case .hackathon:
            return "asst_2E2zrUmcHeHkDIdRg3ruFCfr"
        }
    }
}

struct OpenAIRecipeStep: Codable, Sendable, Hashable {
    let ingredient: String?
    let action: String
    let timeCost: String?
    let fireLevel: String?
}

struct OpenAIRecipe: Codable, Sendable, Hashable {
    let name: String
    let category: String
    let ingredients: [String]
    let totalCost: String
    let steps: [String: [OpenAIRecipeStep]]
    let image: Data?
}

extension OpenAIRecipe {
    static var stub: OpenAIRecipe {
        return try! JSONDecoder().decode(OpenAIRecipe.self, from: Data("""
        {\n    \"name\": \"스파게티\",\n    \"totalCost\": \"약 25분\",\n    \"category\": \"양식\",\n    \"ingredients\": [\"스파게티면🍝\", \"물💧\", \"올리브오일🫒\", \"소금🧂\", \"마늘🧄\", \"양파🧅\", \"토마토소스🍅\", \"소고기 간 것🥩\", \"파마산치즈🧀\", \"후추가루\"],\n    \"steps\": {\n        \"스파게티면_삶기\": [\n            {\"action\": \"재료 넣기\", \"ingredient\": \"물💧\"},\n            {\"action\": \"끓이기\", \"timeCost\": \"7분\", \"fireLevel\": \"강불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"소금🧂\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"스파게티면🍝\"},\n            {\"action\": \"끓이기\", \"timeCost\": \"10분\", \"fireLevel\": \"강불\"},\n            {\"action\": \"불 끄기\"},\n            {\"action\": \"면 건지기\"}\n        ],\n        \"재료_준비하기\": [\n            {\"action\": \"재료 다지기\", \"ingredient\": \"마늘🧄\"},\n            {\"action\": \"재료 다지기\", \"ingredient\": \"양파🧅\"}\n        ],\n        \"소스_만들기\": [\n            {\"action\": \"재료 넣기\", \"ingredient\": \"올리브오일🫒\", \"fireLevel\": \"중불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"마늘🧄\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"양파🧅\"},\n            {\"action\": \"볶기\", \"timeCost\": \"5분\", \"fireLevel\": \"중불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"소고기 간 것🥩\"},\n            {\"action\": \"볶기\", \"timeCost\": \"5분\", \"fireLevel\": \"중불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"토마토소스🍅\"},\n            {\"action\": \"끓이기\", \"timeCost\": \"5분\", \"fireLevel\": \"중불\"},\n            {\"action\": \"재료 넣기\", \"ingredient\": \"후추가루\"}\n        ],\n        \"면과_소스_합치기\": [\n            {\"action\": \"재료 넣기\", \"ingredient\": \"삶은 스파게티면🍝\"},\n            {\"action\": \"섞기\", \"timeCost\": \"2분\"},\n            {\"action\": \"불 끄기\"}\n        ],\n        \"마무리\": [\n            {\"action\": \"재료 넣기\", \"ingredient\": \"파마산치즈🧀\", \"quantity\": \"적당히\"},\n            {\"action\": \"서빙하기\"}\n        ]\n    }\n}
        """.utf8))
    }
    static var stub2: OpenAIRecipe {
        return try! JSONDecoder().decode(OpenAIRecipe.self, from: Data("""
        [
                "name": "스파게티",
                "totalCost": "약 20분",
                "category": "양식",
                "ingredients": ["스파게티 면", "물", "소금", "올리브오일", "마늘", "양파", "토마토 소스", "바질", "후추", "파마산 치즈"],
                "steps": [
                    "스파게티면_삶기": [
                        ["action": "재료 넣기", "ingredient": "물", "timeCost": "- 5분"],
                        ["action": "끓이기", "timeCost": "5분", "fireLevel": "강불"],
                        ["action": "재료 넣기", "ingredient": "소금", "timeCost": "- 5분"],
                        ["action": "재료 넣기", "ingredient": "스파게티 면"],
                        ["action": "끓이기", "timeCost": "8-10분", "fireLevel": "중불"],
                        ["action": "면 건지기"],
                        ["action": "물기 제거하기"]
                    ],
                    "소스_만들기": [
                        ["action": "재료 넣기", "ingredient": "올리브오일", "fireLevel": "중불"],
                        ["action": "재료 넣기", "ingredient": "마늘", "timeCost": "- 1분"],
                        ["action": "재료 넣기", "ingredient": "양파", "timeCost": "- 1분"],
                        ["action": "볶기", "timeCost": "3분", "fireLevel": "중불"],
                        ["action": "재료 넣기", "ingredient": "토마토 소스"],
                        ["action": "재료 넣기", "ingredient": "바질", "timeCost": "- 2분"],
                        ["action": "재료 넣기", "ingredient": "후추", "timeCost": "- 2분"],
                        ["action": "끓이기", "timeCost": "5분", "fireLevel": "약불"]
                    ],
                    "면과_소스_섞기": [
                        ["action": "재료 넣기", "ingredient": "삶아둔 스파게티 면"],
                        ["action": "섞기", "timeCost": "1분", "fireLevel": "중불"],
                        ["action": "불 끄기"],
                        ["action": "재료 넣기", "ingredient": "파마산 치즈", "timeCost": "- 10분"]
                    ]
                ]
            ]
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
        
//        super.init()
        
        if let openAiApiKey = openAiApiKey {
            self.openAI = OpenAI(apiToken: openAiApiKey)
        }
    }
    let stub = """
      {\n    
        \"name\": \"스파게티\",\n
        \"totalCost\": \"약 30분\",\n
        \"category\": \"양식\",\n
        \"ingredients\": [\"스파게티면🍝\", \"물💧\", \"소금🧂\", \"올리브오일🫒\", \"다진 마늘🧄\", \"양파🧅\", \"토마토 소스🍅\", \"다진 쇠고기🥩\", \"후추가루\", \"파마산 치즈 가루🧀\", \"바질🌿\"],\n
        \"steps\": {\n
            \"면_삶기\": [\"재료 넣기|물|1L\", \"끓이기|물이 끓을 때까지|강불\", \"재료 넣기|소금|1 T\", \"재료 넣기|스파게티면🍝|200g\", \"삶기|10분|중불\", \"면 건지기\"],\n
            \"소스_만들기\": [\"재료 넣기|올리브오일🫒|2 T\", \"재료 넣기|다진 마늘🧄|1 T\", \"볶기|1분|중불\", \"재료 넣기|다진 양파🧅|1/2 개\", \"볶기|3분|중불\", \"재료 넣기|다진 쇠고기🥩|100g\", \"볶기|5분|중불\", \"재료 넣기|토마토 소스🍅|1 컵\", \"끓이기|5분|중불\", \"재료 넣기|후추가루|1/4 t\", \"재료 넣기|바질🌿|약간\"],\n
            \"스파게티와_소스_혼합\": [\"재료 넣기|삶은 스파게티면🍝|200g\", \"재료 넣기|토마토 소스|적당량\", \"볶기|3분|중불\", \"불 끄기\", \"재료 넣기|파마산 치즈 가루🧀|1 T\"]\n     
            }\n
        }
    """
    
    func getRecipe(input: String) async throws -> OpenAIRecipe {
        
        return OpenAIRecipe.stub
        
        let chatQuery = ChatQuery(messages: [.system(.init(content: self.defaultPrompt, name: "assistant")), .user(.init(content: .string(input)))], model: .gpt4_o)
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
//
        
    }
    
}


//class OpenAIRecipeRetriever: NSObject, URLSessionDelegate {
//    var session: URLSession!
//    let apiKey: String
//    let host: String = "https://api.openai.com/"
//    
//    let defaultPrompt: String = """
//    너는 모든 요리에 대해 조리 순서를 성실하게 알려줄 수 있는 Hackathon Cooker야.
//
//    주어진 질문에 대한 음식을 만들 수 있는 방법을 한 단계 한 단계 설명해줘야 해.
//
//    답변의 형태는 요리의 이름(name), 요리의 예상 소요 시간과(timeCost), 요리의 모든 재료(ingredients), 그리고 요리를 완성 시키기 위해 순서가 정해져 있는 조리 방법들의 집합이야.
//
//    요리를 위한 조리 방법은 ["볶기","찌기","굽기","데치기","기다리기", "재료 넣기", "불 끄기"] 등이 있을 수 있어, 조리 방법 뒤엔 재료와 양(quantity)이나 시간(time cost)가 포함되어있을 수 있고 "|"로 구분 해야 해.
//
//    요리단계에서 요리재료는 이모티콘(Unicode imoticon)으로 표현이 가능하면 이모티콘(Unicode imoticon)으로 줘야해.
//
//    요리 이미지는 Dall-E로 생성해서, base64로 다운로드 가능해야해
//    [/INST]
//    [EXAMPLE]:
//    {
//        "name": "까르보나라 파스타",
//        "timeCost": "약 15분",
//        "ingredients": ["파스타면", "물","파마산치즈 가루","양파","마늘","후추가루","올리브오일","소금", "베이컨","계란혼합물"]
//        "steps": {
//           "파스타면_삶기": ["재료 넣기|물|1L", "조리행동시간|10초","끓이기|3분|중불", "재료넣기|소금,올리브오일|1/2t,1t", "조리행동시간|10초", "접시로꺼내기"],
//           "🧅와_🥓_볶기": ["재료넣기|🫒오일|2t","볶기|2분|중불", "재료넣기|🧅,🥓,후춧가루|1/4개,50g,1/4t","볶기|3분|중불", "재료넣기|면수|6t", "볶기|1분|중불","불끄기","재료넣기|🥚혼합물|100g"]
//         }
//    }
//    """
//    
//    override init() {
//        let openAiApiKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_AI_API_KEY") as! String
//        self.apiKey = openAiApiKey
//        
//        super.init()
//        
//        self.initSession()
//    }
//    
//    private func initSession() {
//        let urlsessionConfiguration = URLSessionConfiguration.default
//        urlsessionConfiguration.httpAdditionalHeaders = [
//            "Authorization": "Bearer \(self.apiKey)",
//            "Content-Type": "application/json"
//        ]
//        
//        self.session = URLSession(configuration: urlsessionConfiguration, delegate: self, delegateQueue: nil)
//    }
//    
//    private func createPayload(with input: String, model: String = "gpt-4o") throws -> Data {
//        let payload: String = """
//        {
//            "model": "\(model)",
//            "messages": {
//                {
//                    "role": "system",
//                    "content": "\(self.defaultPrompt)"
//                },
//                {
//                    "role": "user",
//                    "content": "\(input)"
//                }
//            }
//        }
//        """
//        
//        let jsonEncoder = JSONEncoder()
//        
//        let data = try jsonEncoder.encode(payload)
//        
//        return data
//    }
//    
//    func getRecipe(input: String) async throws -> String {
//        let urlString = "\(self.host)/\(OpenAIV1EndPoint.chatCompletion.endpoint)"
//        guard let url = URL(string: urlString) else {
//            throw NSError(domain: "OpenAI: Couldn't make a URL with \(urlString)", code: 400)
//        }
//        
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        let payload = try self.createPayload(with: input)
//        urlRequest.httpBody = payload
//        
//        let (data, response) = try await self.session.data(for: urlRequest)
//        
//        return String(data: data, encoding: .utf8)!
//    }
//}
