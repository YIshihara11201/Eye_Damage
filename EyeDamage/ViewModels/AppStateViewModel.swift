//
//  AppStateViewModel.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-29.
//

import Foundation

final class AppStateViewModel: ObservableObject {
	
	var userDefaults: UserDefaultsProtocol = UserDefaults.standard
	let userDefaultObjectKeyReceivedNotification = "receivedNotification"
	let userDefaultObjectKeyReceivedDailyReport = "receivedDailyReport"
	let userDefaultObjectKeyLockRequestSent = "lockRequestSent"
	
	@Published var receivedNotification: Bool
	@Published var receivedDailyReport: Bool
	@Published var lockRequestSent: Bool
	
	init() {
		self.receivedNotification = userDefaults.value(forKey: userDefaultObjectKeyReceivedNotification) as? Bool ?? false
		self.receivedDailyReport = userDefaults.value(forKey: userDefaultObjectKeyReceivedDailyReport) as? Bool ?? true
		self.lockRequestSent = userDefaults.value(forKey: userDefaultObjectKeyLockRequestSent) as? Bool ?? false
	}
	
	func toggleReceivedNotification() {
		if receivedNotification {
			userDefaults.set(false, forKey: userDefaultObjectKeyReceivedNotification)
		} else {
			userDefaults.set(true, forKey: userDefaultObjectKeyReceivedNotification)
		}
		receivedNotification.toggle()
	}
	
	func toggleReceiveDailyReportState() {
		if receivedDailyReport {
			userDefaults.set(false, forKey: userDefaultObjectKeyReceivedDailyReport)
		} else {
			userDefaults.set(true, forKey: userDefaultObjectKeyReceivedDailyReport)
		}
		receivedDailyReport.toggle()
	}
	
	func toggleLockRequestSent() {
		if lockRequestSent {
			userDefaults.set(false, forKey: userDefaultObjectKeyLockRequestSent)
		} else {
			userDefaults.set(true, forKey: userDefaultObjectKeyLockRequestSent)
		}
		lockRequestSent.toggle()
	}
	
}
