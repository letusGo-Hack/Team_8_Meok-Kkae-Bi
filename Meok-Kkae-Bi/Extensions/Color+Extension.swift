//
//  Color+Extension.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import SwiftUI

extension Color {
    static let _mainColor = Color(hex: "EE9127")
    
    static let _western = Color(hex: "FFA07A")
    static let _korean = Color(hex: "dabe86")
    static let _chinese = Color(hex: "ce5f84")
    static let _japanese = Color(hex: "B677D5")
    static let _asian = Color(hex: "BAC8DE")
    
    init(hex: String) {
            let scanner = Scanner(string: hex)
            scanner.scanLocation = 0
            var rgbValue: UInt64 = 0
            scanner.scanHexInt64(&rgbValue)
            
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff
            
            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff
            )
        }
}
