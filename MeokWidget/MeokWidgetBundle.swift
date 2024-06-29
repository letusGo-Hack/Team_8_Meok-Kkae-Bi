//
//  MeokWidgetBundle.swift
//  MeokWidget
//
//  Created by 고병학 on 6/29/24.
//

import WidgetKit
import SwiftUI

@main
struct MeokWidgetBundle: WidgetBundle {
    var body: some Widget {
        MeokWidget()
        MeokWidgetControl()
        MeokWidgetLiveActivity()
    }
}
