//
//  Date+Extensions.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-20.
//

import Foundation

public enum Weekday: String {
	case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

extension Date: RawRepresentable {
	private static let ios8601Formatter = ISO8601DateFormatter()
	
	public var rawValue: String {
		Date.ios8601Formatter.string(from: self)
	}
	
	public init?(rawValue: String) {
		self = Date.ios8601Formatter.date(from: rawValue) ?? Date()
	}
	
	func getWeekDaysInEnglish() -> [String] {
		var calendar = Calendar.current
		calendar.locale = Locale(identifier: "en_US_POSIX")
		return calendar.weekdaySymbols
	}
	
	// last date of weekday (weekday start from sunday)
	public func getLastWeekday(weekday: Weekday) -> Date {
		let dayName = weekday.rawValue
		let weekdaysName = self.getWeekDaysInEnglish().map { $0.lowercased() }
		let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
		
		let calendar = Calendar.current
		let oneWeekBefore = calendar.date(byAdding: .day, value: -7, to: self)!
		var cmp = calendar.dateComponents([.hour, .minute, .second], from: oneWeekBefore)
		cmp.weekday = searchWeekdayIndex
		let date = calendar.nextDate(after: oneWeekBefore, matching: cmp, matchingPolicy: .previousTimePreservingSmallerComponents)
		
		return date!
	}
	
	public func sixDaysAgo() -> Date {
		return Calendar.current.date(byAdding: .day, value: 6, to: self)!
	}
	
	public func midnight() -> Date {
		var midnight: Date = self
		let calendar = Calendar.current
		
		// upper boundary for sleeping start time range is 27:00 (inclusive)
		// after 24:00 (upto 14:00, inclusive), treat previous day's 00:00 as the midnight date
		if midnight.isBetweenZeroToFourteen() {
			let prev = calendar.date(byAdding: .day, value: -1, to: midnight)!
			midnight = prev
		} 
		midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: midnight)!
		
		return midnight
	}
	
	public func isBetweenTwentyOneToTwentyFour() -> Bool { // possible range for start of bedtime before 00:00 AM for the day
		let currHour = Calendar.current.component(.hour, from: self)
		return currHour >= 21 && currHour < 24
	}
	
	public func isBetweenZeroToThree() -> Bool { // possible range for start of bedtime after 00:00 AM
		let currHour = Calendar.current.component(.hour, from: self)
		let currMinute = Calendar.current.component(.minute, from: self)
		let currSecond = Calendar.current.component(.second, from: self)
		if currHour == 3 {
			return currMinute == 0 && currSecond == 0
		} else {
			return currHour >= 0 && currHour < 3
		}
	}
	
	public func isBetweenZeroToFourteen() -> Bool { // possible range for sleeping time after 00:00 AM
		let currHour = Calendar.current.component(.hour, from: self)
		let currMinute = Calendar.current.component(.minute, from: self)
		let currSecond = Calendar.current.component(.second, from: self)
		if currHour == 14 {
			return currMinute == 0 && currSecond == 0
		} else {
			return currHour >= 0 && currHour < 14
		}
	}
	
}
