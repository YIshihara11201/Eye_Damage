//
//  LocalNotification.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-19.
//

import Foundation
import UserNotifications

class LocalNotification {
	static let shared = LocalNotification()
	
	let sleepStartIdentifier = "SLEEP_START_IDENTIFIER"
	var center: UNUserNotificationCenter = UNUserNotificationCenter.current()
	
	func authorize() {
		center.requestAuthorization(options: [.badge, .alert, .sound]) { (_: Bool, _: Error?) in }
	}
	
	func sendScheduleNotification(triggerTime: DateComponents) {
		let content = UNMutableNotificationContent()
		content.title = "Bedtime"
		content.body = "It is about time!"
		
		let dateComponents = triggerTime
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
		let request = UNNotificationRequest(identifier: sleepStartIdentifier, content: content, trigger: trigger)
		
		center.add(request) {( _ ) in }
	}
	
	func setLocalNotification(date: Date) {
		let triggerDateComps = Calendar.current.dateComponents([.hour, .minute], from: date)
		LocalNotification.shared.center.getNotificationSettings(completionHandler: { settings in
			if settings.authorizationStatus == .authorized {
				self.sendScheduleNotification(triggerTime: triggerDateComps)
			}
		})
	}
	
}
