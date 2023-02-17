//
//  AppDelegate.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-19.
//

import Foundation
import UIKit
import ActivityKit
import LocalAuthentication

class AppDelegate: UIResponder, UIApplicationDelegate {
	var timerVM = TimerViewModel()
	var appStateVM = AppStateViewModel()
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		LocalNotification.shared.center.delegate = self
		LocalNotification.shared.authorize()
		Task {
			await MainActor.run {
				application.registerForRemoteNotifications()
			}
		}
		
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken token: Data) {
		let tokenRequest = Requests.shared.buildTokenRequest(pushToken: token, activityToken: nil)
		Task {
			try await Requests.shared.send(request: tokenRequest)
		}
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
		await Activities.terminateActivity()
		
		return .noData // always return no data (regardless termination succeeds or not)
	}
	
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.list, .sound, .banner])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		if response.notification.request.identifier == LocalNotification.shared.sleepStartIdentifier {
			
			if Date() >= timerVM.wakeUp { return } // dissmiss notification after wake up time
			
			appStateVM.toggleReceivedNotification()
			appStateVM.toggleReceiveDailyReportState()
			
			do {
				let activity = try Activities.startActivity()
				Task {
					await Activities.sendTokenRequest(for: activity)
					let currentDate = Date()
					let recordDate = currentDate.midnight()
					let smartphoneTimeRequest = Requests.shared.buildSmartphoneTimeRequest(
						recordDate: recordDate,
						start: currentDate,
						end: nil,
						requestType: .create)
					let reportRequest = Requests.shared.buildReportRequest(recordDate: recordDate, requestType: .create)
					try await Requests.shared.send(request: smartphoneTimeRequest)
					try await Requests.shared.send(request: reportRequest)
				}
			} catch {
				fatalError("\(error)")
			}
		}
		
		completionHandler()
	}
	
}
