//
//  HapticGenerator.swift
//  Meok-Kkae-Bi
//
//  Created by 고병학 on 6/29/24.
//

import UIKit

final class HapticManager {
    
    static let instance = HapticManager()
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private init() {}
    
    func generateHaptic() {
        feedbackGenerator.impactOccurred()
    }
}
