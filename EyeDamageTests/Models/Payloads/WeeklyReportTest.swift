//
//  WeeklyReportTest.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-29.
//

@testable import EyeDamage
import XCTest

final class WeeklyReportTest: XCTestCase {
	private var sut: WeeklyReport!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = WeeklyReport(startDayOfWeek:.now)
	}

	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}

	func test_getWeeklyDuration_withNoDailyReport_shouldReturn0() {
		sut.reports = []
		
		let actual = sut.getWeeklyDuration()
		
		XCTAssertEqual(actual, 0)
	}
	
	func test_getWeeklyDuration_withOneDailyReport_shouldReturn10() {
		let currDate = Date()
		sut.reports = [DailyReport(startDayOfWeek: currDate, weekDay: .monday, duration: 10)]
		
		let actual = sut.getWeeklyDuration()
		
		XCTAssertEqual(actual, 10)
	}
	
	func test_getWeeklyDuration_withThreeDailyReports_shouldReturn30() {
		let currDate = Date()
		sut.reports = [
			DailyReport(startDayOfWeek: currDate, weekDay: .monday, duration: 10),
			DailyReport(startDayOfWeek: currDate, weekDay: .tuesday, duration: 10),
			DailyReport(startDayOfWeek: currDate, weekDay: .wednesday, duration: 10)
		]
		
		let actual = sut.getWeeklyDuration()
		
		XCTAssertEqual(actual, 30)
	}
	
	func test_longestDuration_allReportsHave0Duration_shouldReturn0() {
		let currDate = Date()
		sut.reports = [
			DailyReport(startDayOfWeek: currDate, weekDay: .monday, duration: 0),
			DailyReport(startDayOfWeek: currDate, weekDay: .tuesday, duration: 0),
			DailyReport(startDayOfWeek: currDate, weekDay: .wednesday, duration: 0)
		]
		
		let actual = sut.longestDuration()
		
		XCTAssertEqual(actual, 0)
	}
	
	func test_longestDuration_largestIs30_shouldReturn30() {
		let currDate = Date()
		sut.reports = [
			DailyReport(startDayOfWeek: currDate, weekDay: .monday, duration: 10),
			DailyReport(startDayOfWeek: currDate, weekDay: .tuesday, duration: 30),
			DailyReport(startDayOfWeek: currDate, weekDay: .wednesday, duration: 30)
		]
		
		let actual = sut.longestDuration()
		
		XCTAssertEqual(actual, 30)
	}
	
	// emptyWeekReports does not have a dependency from external services and nor affect object state,
	// thus, see it as testable method
	func test_emptyWeekReports_shoudHaveSevenDailyReports() {
		let res = WeeklyReport.emptyWeekReports(startDay: .now)
		
		XCTAssertEqual(res.reports.count, 7)
	}

}
