//
//  EyeDamageWidgetLiveActivityAttributes.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-19.
//
import Foundation
import ActivityKit

struct EyeDamageWidgetAttributes: ActivityAttributes {
	public struct ContentState: Codable, Hashable {
		var phoneActiveTime: Int
	}
	var name: String
	var timePassed: Date
}
