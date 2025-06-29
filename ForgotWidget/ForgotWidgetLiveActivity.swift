//
//  ForgotWidgetLiveActivity.swift
//  ForgotWidget
//
//  Created by VC on 29/6/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ForgotWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ForgotWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ForgotWidgetAttributes.self) { context in
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

extension ForgotWidgetAttributes {
    fileprivate static var preview: ForgotWidgetAttributes {
        ForgotWidgetAttributes(name: "World")
    }
}

extension ForgotWidgetAttributes.ContentState {
    fileprivate static var smiley: ForgotWidgetAttributes.ContentState {
        ForgotWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ForgotWidgetAttributes.ContentState {
         ForgotWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ForgotWidgetAttributes.preview) {
   ForgotWidgetLiveActivity()
} contentStates: {
    ForgotWidgetAttributes.ContentState.smiley
    ForgotWidgetAttributes.ContentState.starEyes
}
