//
//  AllReport.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2023-01-29.
//

import Foundation

struct AllReport: Codable {
	var reports: [WeeklyReport] = []
	
	func getWeekReports(firstWeekDay: Date) -> WeeklyReport {
		// make empty weekly report (seven daily reports)
		let res = WeeklyReport.emptyWeekReports(startDay: firstWeekDay)
		
		// get weekly report from all reports
		if let wReport = self.reports.first(where: { report in
			report.startDayOfWeek == firstWeekDay
		}) {
			// fill in empty daily reports
			for emptyDReport in res.reports {
				
				// dReport -> actual daily report
				guard let dReport = wReport.reports.first(where: { report in
					emptyDReport.weekDay == report.weekDay
				}) else { continue }
				
				// fill in empty reports with actual values
				res.reports.first(where: { emptyDReport in
					emptyDReport.weekDay == dReport.weekDay
				})?.duration = dReport.duration
			}
		}
		
		return res
	}
	
	func oldestDate() -> Date {
		let ascReports = reports.sorted(by: {
			$0.startDayOfWeek < $1.startDayOfWeek
		})
		let oldest = ascReports.first!.startDayOfWeek
		
		return oldest
	}
	
}

extension AllReport: CustomStringConvertible {
	func encoded() -> Data {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		return try! encoder.encode(self)
	}
	
	var description: String {
		return String(data: encoded(), encoding: .utf8) ?? "Invalid report"
	}
}
