//
//  TimerViewModel.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-20.
//

import Foundation

final class TimerViewModel: ObservableObject {
	
	var userDefaults: UserDefaultsProtocol = UserDefaults.standard
	let userDefaultObjectKeyForBedtime = "bedtime"
	let userDefaultObjectKeyForWakeUp = "wake up"
	
	@Published var bedtime: Date!
	@Published var wakeUp: Date!
	@Published var userDefaultsBedtime: Date? = nil
	@Published var userDefaultsWakeUp: Date? = nil
	
	init() {
		let currDate = Date()
		self.bedtime = getInitialBedtime(currentDate: currDate)
		self.wakeUp = getInitialWakeUp(currendDate: currDate)
		
		// if timer has been set, use the values for initial setting
		if self.hasStoredTimer() {
			self.userDefaultsBedtime = (userDefaults.object(forKey: userDefaultObjectKeyForBedtime) as! Date)
			self.userDefaultsWakeUp = (userDefaults.object(forKey: userDefaultObjectKeyForWakeUp) as! Date)
			self.bedtime = self.userDefaultsBedtime!
			self.wakeUp = self.userDefaultsWakeUp!
		}
	}
	
	func getInitialBedtime(currentDate: Date) -> Date {
		let date: Date!
		if currentDate.isBetweenZeroToThree() {
			date = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
		} else {
			date = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: currentDate)!
		}
		return date
	}
	
	func getInitialWakeUp(currendDate: Date) -> Date {
		let initialBedTime = getInitialBedtime(currentDate: currendDate)
		return Calendar.current.date(byAdding: .hour, value: 7, to: initialBedTime)!
	}
	
	func getBedtimeForToday() -> Date {
		let currDate = Date()
		let currYear = Calendar.current.dateComponents(in: .current, from: currDate).year
		let currMonth = Calendar.current.dateComponents(in: .current, from: currDate).month
		let currDay = Calendar.current.dateComponents(in: .current, from: currDate).day
		var bedtimeCmps = DateComponents()
		bedtimeCmps.year = currYear
		bedtimeCmps.month = currMonth
		bedtimeCmps.day = currDay
		bedtimeCmps.hour = Calendar.current.dateComponents(in: .current, from: self.bedtime).hour
		bedtimeCmps.minute = Calendar.current.dateComponents(in: .current, from: self.bedtime).minute
		
		let date = Calendar.current.date(from: bedtimeCmps)!
		let dateFormatter = ISO8601DateFormatter()
		let ios8601Date = dateFormatter.date(from: date.rawValue)!
		
		return ios8601Date
	}
	
	func getWakeUpTimeForTomorrow() -> Date {
		let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
		let tomorrowYear = Calendar.current.dateComponents(in: .current, from: tomorrowDate).year
		let tomorrowMonth = Calendar.current.dateComponents(in: .current, from: tomorrowDate).month
		let tomorrowDay = Calendar.current.dateComponents(in: .current, from: tomorrowDate).day
		var wakeUpCmps = DateComponents()
		wakeUpCmps.year = tomorrowYear
		wakeUpCmps.month = tomorrowMonth
		wakeUpCmps.day = tomorrowDay
		wakeUpCmps.hour = Calendar.current.dateComponents(in: .current, from: self.wakeUp).hour
		wakeUpCmps.minute = Calendar.current.dateComponents(in: .current, from: self.wakeUp).minute
		
		let date = Calendar.current.date(from: wakeUpCmps)!
		let dateFormatter = ISO8601DateFormatter()
		let ios8601Date = dateFormatter.date(from: date.rawValue)!
		return ios8601Date
	}
	
	func getLiveActivityEndTime() -> Date {
		// Live Activity ends automaticallly 8 hours after it starts
		// To prevent display time from being 0min 0sec, end the activity 5 minutes before auto-termination
		var endTime =  Calendar.current.date(byAdding: .hour, value: 7, to: self.bedtime)!
		endTime = Calendar.current.date(byAdding: .minute, value: 55, to: endTime)!
		
		return endTime
	}
	
	func storeTimer() {
		userDefaults.set(bedtime, forKey: userDefaultObjectKeyForBedtime)
		userDefaults.set(wakeUp, forKey: userDefaultObjectKeyForWakeUp)
		self.userDefaultsBedtime = bedtime
		self.userDefaultsWakeUp = wakeUp
	}
	
	func hasStoredTimer() -> Bool {
		return userDefaults.object(forKey: userDefaultObjectKeyForBedtime) != nil
		&& userDefaults.object(forKey: userDefaultObjectKeyForWakeUp) != nil
		&& userDefaultsBedtime != nil
		&& userDefaultsWakeUp != nil
	}
	
	func shiftOnedayAhead() {
		let nextBedtime = Calendar.current.date(byAdding: .day, value: 1, to: bedtime)!
		let nextWakeUp = Calendar.current.date(byAdding: .day, value: 1, to: wakeUp)!
		
		self.bedtime = nextBedtime
		self.wakeUp = nextWakeUp
		storeTimer()
	}
	
	func getBedtimeRange(currentDate: Date) -> ClosedRange<Date> {
		let lowerBoundary = 21
		let upperBoundary = 27
		
		var bedtimeLow: Date
		if currentDate.isBetweenZeroToThree() {
			let oneDayBefore = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
			bedtimeLow = Calendar.current.date(bySettingHour: lowerBoundary, minute: 0, second: 0, of: oneDayBefore)!
		} else {
			bedtimeLow = Calendar.current.date(bySettingHour: lowerBoundary, minute: 0, second: 0, of: currentDate)!
		}
		
		let bedtimeHigh = Calendar.current.date(byAdding: .hour, value: upperBoundary-lowerBoundary, to: bedtimeLow)!
		
		return bedtimeLow...bedtimeHigh
	}
	
	func getWakeupTimeRange() -> ClosedRange<Date> {
		let shortestSleepingHour = 5
		let longestSleepingHour = 11
		
		let wakeUpLow = Calendar.current.date(byAdding: .hour, value: shortestSleepingHour, to: self.bedtime)!
		let wakeUpHigh = Calendar.current.date(byAdding: .hour, value: longestSleepingHour-shortestSleepingHour, to: wakeUpLow)!
		
		return wakeUpLow...wakeUpHigh
	}
	
}
