//
//  MeokWidgetLiveActivity.swift
//  MeokWidget
//
//  Created by 고병학 on 6/29/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

public struct MeokWidgetAttributes: ActivityAttributes {
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
            VStack {
                Text("🫒 올리브 오일 2t 넣기")
                    .fontWeight(.semibold)
                ProgressView(value: 0.3, total: 1)
                    .padding(.horizontal)
                HStack {
                    Text("00:00")
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                    Spacer()
                    Text("00:43")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("01:30")
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                }
                .padding(.horizontal)
            }
            .activityBackgroundTint(Color.orange)
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
                    VStack {
                        Spacer()
                        Text("🫒 올리브 오일 2t 넣기")
                            .fontWeight(.semibold)
                        ProgressView(value: 0.3, total: 1)
                            .padding(.horizontal)
                        HStack {
                            Text("00:00")
                                .font(.caption2)
                                .foregroundStyle(Color.gray)
                            Spacer()
                            Text("00:43")
                                .font(.caption)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("01:30")
                                .font(.caption2)
                                .foregroundStyle(Color.gray)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
            } compactLeading: {
                Text("🍳")
            } compactTrailing: {
                Text("🫒 3:12")
            } minimal: {
                Text("🫒")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
        .supplementalActivityFamilies([.small])
    }
}

extension MeokWidgetAttributes {
    fileprivate static var preview: MeokWidgetAttributes {
        MeokWidgetAttributes(name: "World")
    }
}

extension MeokWidgetAttributes.ContentState {
    fileprivate static var smiley: MeokWidgetAttributes.ContentState {
        MeokWidgetAttributes.ContentState(emoji: "🥕")
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
