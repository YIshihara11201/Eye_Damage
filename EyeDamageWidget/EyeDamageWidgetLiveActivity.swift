//
//  EyeDamageWidgetLiveActivity.swift
//  EyeDamageWidget
//
//  Created by Yusuke Ishihara on 2022-11-19.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct EyeDamageWidgetLiveActivity: Widget {
	var body: some WidgetConfiguration {
		
		ActivityConfiguration(for: EyeDamageWidgetAttributes.self) { context in
			LockScreenView(context: context)
				.background(Color(red: 232/243, green: 1, blue: 213/243))
				.widgetURL(URL(string: "2"))
		} dynamicIsland: { context in
			DynamicIsland {
				DynamicIslandExpandedRegion(.leading) {
					VStack(alignment: .center) {
						Image(systemName: "timer")
					}
				}
				DynamicIslandExpandedRegion(.trailing) {
					Text(context.attributes.timePassed, style: .timer)
						.multilineTextAlignment(.center)
						.frame(width: 30)
						.font(.caption)
				}
				DynamicIslandExpandedRegion(.bottom) {
					HStack(alignment: .center) {
						Image(systemName: "bed.double.fill")
						Text("Tap before sleep")
					}
				}
			} compactLeading: {
				Image(systemName: "timer")
			} compactTrailing: {
				Text(context.attributes.timePassed, style: .timer)
					.multilineTextAlignment(.center)
					.frame(width: 30)
					.font(.caption)
			} minimal: {
				VStack(alignment: .center) {
					Image(systemName: "timer")
					Text(context.attributes.timePassed, style: .timer)
						.multilineTextAlignment(.center)
						.monospacedDigit()
						.font(.caption2)
				}
			}
			.keylineTint(Color.red)
		}
	}
}
