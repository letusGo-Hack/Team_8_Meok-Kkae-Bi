//
//  Untitled.swift
//  Meok-Kkae-Bi
//
//  Created by DY on 6/29/24.
//

import UIKit

/// 요리 동작
enum CookActionType: String, CaseIterable {
    /// 완료
    case complete
    /// 끓이기, 조림
    case boil
    /// 넣기
    case put
    /// 튀기기
    case fry
    /// 자르기, 다지기
    case chop
    /// 삶기, 찌기
    case steam
    /// 볶기
    case stirfry
    /// 해동
    case thaw
    /// 오븐
    case oven
    /// 굽기
    case roast
    /// 면 건지기
    case noodle
    /// 찾을 수 없음
    case unknown
    
    static func getCookActionType(value: String) -> Self {
        return CookActionType(rawValue: value) ?? .unknown
    }
    
    var image: UIImage {
        switch self {
        case .complete: .imgCookComplete
        case .boil: .imgCookBoil
        case .put: .imgCookPut
        case .fry: .imgCookFry
        case .chop: .imgCookChop
        case .steam: .imgCookSteam
        case .stirfry: .imgCookStirfry
        case .thaw: .imgCookThaw
        case .oven: .imgCookOven
        case .roast: .imgCookRoast
        case .noodle: .imgCookNoodle
        case .unknown: .imgCookNodata
        }
    }
}
