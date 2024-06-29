//
//  chat.swift
//  Meok-Kkae-BiTests
//
//  Created by Minsoo Kim on 6/29/24.
//

import Testing
import Foundation

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

struct OpenAIRecipeStep: Codable, Sendable {
    let description: String
    let quantity: String
    let timeCost: Int
}

struct OpenAIRecipe: Codable, Sendable {
    let name: String
    let category: String
    let ingredients: [String]
    let totalCost: Int
    let steps: [OpenAIRecipeStep]
    let image: Data?
}


@MainActor
class OpenAIRecipeRetriever: NSObject, URLSessionDelegate {
    var session: URLSession!
    let apiKey: String
    let host: String = "https://api.openai.com/"
    
    override init() {
        let openAiApiKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_AI_API_KEY") as! String
        self.apiKey = openAiApiKey
        
        super.init()
        
        self.initSession()
    }
    
    func initSession() {
        var urlsessionConfiguration = URLSessionConfiguration.default
        urlsessionConfiguration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(self.apiKey)",
            "Content-Type": "application/json"
        ]
        
        self.session = URLSession(configuration: urlsessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func
    
    
    func getRecipe() async throws -> String {
        let urlString = "\(self.host)/\(OpenAIV1EndPoint.chatCompletion.endpoint)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "OpenAI: Couldn't make a URL with \(urlString)", code: 400)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let (data, response) = try await self.session.data(from: url)
        
        return String(data: data, encoding: .utf8)!
    }
    
    
}

struct Chat {
    
    

    @Test func shouldSucceedToGetRecipe() async throws {
        let recipeRetriever = await OpenAIRecipeRetriever()
        let recipe = try await recipeRetriever.getRecipe()
        
        print(recipe)
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}

