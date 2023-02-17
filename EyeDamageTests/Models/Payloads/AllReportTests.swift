//
//  AllReportTests.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-29.
//

@testable import EyeDamage
import XCTest

final class AllReportTests: XCTestCase {
	
	private var sut: AllReport!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = AllReport()
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func test_getWeekReports_forCurrentWeek_shouldReturnReportsForTheWeek() {
		let currDate = Date()
		let startOfThisWeek = currDate.getLastWeekday(weekday: .sunday)
		let startOfNextWeek = Calendar.current.date(byAdding: .day, value: 7, to: startOfThisWeek)!
		let wReportForThisWeek = WeeklyReport(startDayOfWeek: startOfThisWeek, reports: [
			DailyReport(startDayOfWeek: startOfThisWeek, weekDay: .sunday, duration: 0),
			DailyReport(startDayOfWeek: startOfThisWeek, weekDay: .monday, duration: 0),
			DailyReport(startDayOfWeek: startOfThisWeek, weekDay: .tuesday, duration: 0),
			DailyReport(startDayOfWeek: startOfThisWeek, weekDay: .wednesday, duration: 0),
			DailyReport(startDayOfWeek: startOfThisWeek, weekDay: .thursday, duration: 0),
			DailyReport(startDayOfWeek: startOfThisWeek, weekDay: .friday, duration: 0),
			DailyReport(startDayOfWeek: startOfThisWeek, weekDay: .saturday, duration: 0)
		])
		let wReportForNextWeek = WeeklyReport(startDayOfWeek: startOfNextWeek, reports: [
			DailyReport(startDayOfWeek: startOfNextWeek, weekDay: .sunday, duration: 0),
			DailyReport(startDayOfWeek: startOfNextWeek, weekDay: .monday, duration: 0),
			DailyReport(startDayOfWeek: startOfNextWeek, weekDay: .tuesday, duration: 0),
			DailyReport(startDayOfWeek: startOfNextWeek, weekDay: .wednesday, duration: 0),
			DailyReport(startDayOfWeek: startOfNextWeek, weekDay: .thursday, duration: 0),
			DailyReport(startDayOfWeek: startOfNextWeek, weekDay: .friday, duration: 0),
			DailyReport(startDayOfWeek: startOfNextWeek, weekDay: .saturday, duration: 0)
		])
		sut.reports = [
			wReportForThisWeek,
			wReportForNextWeek
		]
		
		let actual = sut.getWeekReports(firstWeekDay: startOfThisWeek)
		XCTAssertEqual(actual.reports.count, 7)
		for actReport in actual.reports {
			XCTAssertTrue(wReportForThisWeek.reports.contains { report in
				report.startDayOfWeek == actReport.startDayOfWeek
				&& report.weekDay == actReport.weekDay
				&& report.duration == actReport.duration
			})
		}
	}
	
	func test_oldestDate_oldestIsToday_shouldReturnToday() {
		let currDate = Date()
		let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currDate)!
		sut.reports = [
			WeeklyReport(startDayOfWeek: currDate, reports: [
				DailyReport(startDayOfWeek: currDate, weekDay: .sunday, duration: 0),
				DailyReport(startDayOfWeek: currDate, weekDay: .monday, duration: 0),
				DailyReport(startDayOfWeek: currDate, weekDay: .tuesday, duration: 0),
				DailyReport(startDayOfWeek: currDate, weekDay: .wednesday, duration: 0),
				DailyReport(startDayOfWeek: currDate, weekDay: .thursday, duration: 0),
				DailyReport(startDayOfWeek: currDate, weekDay: .friday, duration: 0),
				DailyReport(startDayOfWeek: currDate, weekDay: .saturday, duration: 0)
			]),
			WeeklyReport(startDayOfWeek: tomorrow, reports: [
				DailyReport(startDayOfWeek: tomorrow, weekDay: .sunday, duration: 0),
				DailyReport(startDayOfWeek: tomorrow, weekDay: .monday, duration: 0),
				DailyReport(startDayOfWeek: tomorrow, weekDay: .tuesday, duration: 0),
				DailyReport(startDayOfWeek: tomorrow, weekDay: .wednesday, duration: 0),
				DailyReport(startDayOfWeek: tomorrow, weekDay: .thursday, duration: 0),
				DailyReport(startDayOfWeek: tomorrow, weekDay: .friday, duration: 0),
				DailyReport(startDayOfWeek: tomorrow, weekDay: .saturday, duration: 0)
			]),
		]
		
		let actual = sut.oldestDate()
		XCTAssertEqual(actual, currDate)
	}
	
}
