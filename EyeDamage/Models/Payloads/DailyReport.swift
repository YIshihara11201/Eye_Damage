//
//  DailyReport.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-30.
//

import Foundation

enum ReportError: Error {
	case invalidWeekDay
}

enum WeekDay: String, Codable {
	case sunday = "Sun"
	case monday = "Mon"
	case tuesday = "Tue"
	case wednesday = "Wed"
	case thursday = "Thu"
	case friday = "Fri"
	case saturday = "Sat"
	
	static func numToCase(num: Int) throws -> WeekDay {
		switch num {
		case 1: return .sunday
		case 2: return .monday
		case 3: return .tuesday
		case 4: return .wednesday
		case 5: return .thursday
		case 6: return .friday
		case 7: return .saturday
		default: throw ReportError.invalidWeekDay
		}
	}
	
}

class DailyReport: Codable, Identifiable, Equatable {
	let id = UUID()
	let startDayOfWeek: Date
	let weekDay: WeekDay
	var duration: Int
	
	enum CodingKeys: CodingKey {
		case startDayOfWeek, weekDay, duration
	}
	
	init(startDayOfWeek: Date, weekDay: WeekDay, duration: Int) {
		self.startDayOfWeek = startDayOfWeek
		self.weekDay = weekDay
		self.duration = duration
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let startDayOfWeekStr = try container.decode(String.self, forKey: .startDayOfWeek)
		startDayOfWeek = Date(rawValue: startDayOfWeekStr)!
		weekDay = try container.decode(WeekDay.self, forKey: .weekDay)
		duration = try container.decode(Int.self, forKey: .duration)
	}
	
	static func == (lhs: DailyReport, rhs: DailyReport) -> Bool {
		return lhs.startDayOfWeek == rhs.startDayOfWeek && lhs.weekDay == rhs.weekDay && lhs.duration == rhs.duration
	}
	
}
