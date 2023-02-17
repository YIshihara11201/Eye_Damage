//
//  Activities.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-23.
//

import Foundation
import ActivityKit

struct Activities {
	
	static func startActivity() throws -> Activity<EyeDamageWidgetAttributes> {
		do {
			let activity = try Activity.request(
				attributes: EyeDamageWidgetAttributes(name: "Sleep Timer", timePassed: Date()),
				contentState: EyeDamageWidgetAttributes.ContentState(phoneActiveTime: 0),
				pushType: .token)
			return activity
		} catch {
			fatalError("\(error)")
		}
	}
	
	static func sendTokenRequest(for activity: Activity<EyeDamageWidgetAttributes>) async {
		var token: Data? = nil
		for await data in activity.pushTokenUpdates {
			// token can be set only via network communication -> untestable
			token = data
			guard let activityToken = token else { return }
			if let storedToken = UserDefaults.standard.object(forKey: Token.userDefaultActivityTokenKey) as? Data {
				if activityToken == storedToken {
					return
				}
			}
			
			let request = Requests.shared.buildTokenRequest(pushToken: nil, activityToken: activityToken)
			do {
				try await Requests.shared.send(request: request)
				UserDefaults.standard.set(activityToken, forKey: Token.userDefaultActivityTokenKey)
			} catch {
				return
			}
		}
	}
	
	static func terminateActivity() async {
		if let lastActivity = Activity<EyeDamageWidgetAttributes>.activities.first {
			await Activity<EyeDamageWidgetAttributes>.activities.first!.end(using: lastActivity.contentState, dismissalPolicy: .default)
		}
	}
	
	static func checkExistingActivity() -> Bool {
		return Activity<EyeDamageWidgetAttributes>.activities.count != 0
	}
	
	static func hasStoredToken() -> Bool {
		return UserDefaults.standard.object(forKey: Token.userDefaultActivityTokenKey) != nil
	}
	
}
