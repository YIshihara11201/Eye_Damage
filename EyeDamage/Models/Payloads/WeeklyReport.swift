//
//  WeeklyReport.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2023-01-29.
//

import Foundation

struct WeeklyReport: Codable {
	let startDayOfWeek: Date
	var reports: [DailyReport]
	
	enum CodingKeys: CodingKey {
		case startDayOfWeek, reports
	}
	
	init(startDayOfWeek: Date, reports: [DailyReport] = []) {
		self.startDayOfWeek = startDayOfWeek
		self.reports = reports
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let startDayOfWeekStr = try container.decode(String.self, forKey: .startDayOfWeek)
		startDayOfWeek = Date(rawValue: startDayOfWeekStr)!
		reports = try container.decode([DailyReport].self, forKey: .reports)
	}
	
	func getWeeklyDuration() -> Int {
		var total = 0
		for report in reports {
			total += report.duration
		}
		return total
	}
	
	func longestDuration() -> Int {
		var largest = 0
		for report in self.reports {
			if report.duration > largest {
				largest = report.duration
			}
		}
		return largest
	}
	
	static func emptyWeekReports(startDay: Date) -> WeeklyReport {
		var emptyReports = WeeklyReport(startDayOfWeek: startDay)
		let daysInWeek = 7
		
		for i in 1...daysInWeek {
			do {
				let weekDay = try WeekDay.numToCase(num: i)
				let dailyReport = DailyReport(startDayOfWeek: startDay, weekDay: weekDay, duration: 0)
				emptyReports.reports.append(dailyReport)
			} catch {
				fatalError("\(error)")
			}
		}
		
		return emptyReports
	}
	
}

extension WeeklyReport: CustomStringConvertible {
    func encoded() -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try! encoder.encode(self)
    }
    
    var description: String {
        return String(data: encoded(), encoding: .utf8) ?? "Invalid weekly report"
    }
}
