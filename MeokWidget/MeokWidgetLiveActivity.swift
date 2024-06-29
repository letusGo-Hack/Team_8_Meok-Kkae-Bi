//
//  MeokWidgetLiveActivity.swift
//  MeokWidget
//
//  Created by 고병학 on 6/29/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MeokWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MeokWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MeokWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MeokWidgetAttributes {
    fileprivate static var preview: MeokWidgetAttributes {
        MeokWidgetAttributes(name: "World")
    }
}

extension MeokWidgetAttributes.ContentState {
    fileprivate static var smiley: MeokWidgetAttributes.ContentState {
        MeokWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MeokWidgetAttributes.ContentState {
         MeokWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MeokWidgetAttributes.preview) {
   MeokWidgetLiveActivity()
} contentStates: {
    MeokWidgetAttributes.ContentState.smiley
    MeokWidgetAttributes.ContentState.starEyes
}
