//
//  CategoryType.swift
//  Meok-Kkae-Bi
//
//  Created by DY on 6/29/24.
//

import UIKit
import SwiftUI

/// 요리 종류
enum CategoryType: String, CaseIterable {
    case 양식
    case 한식
    case 중식
    case 일식
    case 아시안
    case unknown
    
    static func create(value: String) -> Self {
        return CategoryType(rawValue: value) ?? .unknown
    }
    
    var color: Color {
        switch self {
        case .양식: ._western
        case .한식: ._korean
        case .중식: ._chinese
        case .일식: ._japanese
        case .아시안: ._asian
        default: ._mainColor
        }
    }
    
    var image: UIImage? {
        switch self {
        case .양식: .imgFoodWestern
        case .한식: .imgFoodKorean
        case .중식: .imgFoodJapanese
        case .일식: .imgFoodJapanese
        case .아시안: .imgFoodAsian
        default: .imgFoodKorean
        }
    }
}
