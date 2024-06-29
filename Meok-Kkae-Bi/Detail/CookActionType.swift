//
//  CookActionType.swift
//  Meok-Kkae-Bi
//
//  Created by DY on 6/29/24.
//

import UIKit

/// 요리 동작
enum CookActionType: String, CaseIterable {
    case 완료
    case 끓이기
    case 조림
    case 넣기
    case 튀기기
    case 자르기
    case 다지기
    case 삶기
    case 찌기
    case 볶기
    case 해동
    case 오븐
    case 굽기
    case 건지기
    /// 찾을 수 없음
    case unknown
    
    static func getCookActionType(value: String) -> Self {
        return CookActionType(rawValue: value) ?? .unknown
    }
    
    var image: UIImage {
        switch self {
        case .완료: .imgCookComplete
        case .끓이기, .조림: .imgCookBoil
        case .넣기: .imgCookPut
        case .튀기기: .imgCookFry
        case .자르기, .다지기: .imgCookChop
        case .삶기, .찌기: .imgCookSteam
        case .볶기: .imgCookStirfry
        case .해동: .imgCookThaw
        case .오븐: .imgCookOven
        case .굽기: .imgCookRoast
        case .건지기: .imgCookNoodle
        case .unknown: .imgCookNodata
        }
    }
}
