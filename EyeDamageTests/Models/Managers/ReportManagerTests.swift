//
//  ReportManagerTests.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-30.
//

@testable import EyeDamage
import XCTest

final class ReportManagerTests: XCTestCase {
	
	private let sut = ReportManager.self
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut.fileManager = FakeFileManager()
		sut.dataHandler = FakeDataHandler()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
	
	func test_hasFile_withoutTargetFileInPersistence_shouldReturnFalse() {
		let actual = sut.hasFile(fileName: "the file")
		
		XCTAssertFalse(actual)
	}
	
	func test_hasFile_withTargetFileInPersistence_shouldReturnTrue() throws {
		let existingFileName = sut.fileName
		let dummyData = "dummy data".data(using: .utf8)!
		var url = sut.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		url = url.appendingPathComponent("\(existingFileName)")
		url = url.appendingPathExtension("data")
		
		try sut.dataHandler.write(data: dummyData, url: url, options: [])
		let actual = sut.hasFile(fileName: existingFileName)
		
		XCTAssertTrue(actual)
	}
	
	func test_loadReport_withNoReport_shouldReturnNil() throws {
		let actual = try sut.loadReport()
		
		XCTAssertNil(actual)
	}
	
	func test_loadReport_withExistingData_shouldReturnTheData() throws {
		let existingFileName = sut.fileName
		let existingString = "dummy data"
		let dummyData = existingString.data(using: .utf8)!
		var url = sut.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		url = url.appendingPathComponent("\(existingFileName)")
		url = url.appendingPathExtension("data")
		try sut.dataHandler.write(data: dummyData, url: url, options: [])
		
		let res = try sut.loadReport()
		
		XCTAssertNotNil(res)
		XCTAssertEqual(String(decoding: res!, as: UTF8.self), existingString)
	}
	
	func test_updateReport_withNoPreviousReport_shouldReturnReportsContainingOnlyNewReport() throws {
		let startDayOfWeek = Date().getLastWeekday(weekday: .sunday)
		let beforeUpdate = try JSONEncoder().encode(AllReport())
		let newReport = DailyReport(startDayOfWeek: startDayOfWeek, weekDay: .sunday, duration: 100)
		
		let updatedData = try sut.updateReport(beforeUpdate: beforeUpdate, targetWeek: startDayOfWeek, newReport: newReport)
		let act = try JSONDecoder().decode(AllReport.self, from: updatedData)
		
		let actWeeklyReport = act.reports[0]
		let actDailyReport = actWeeklyReport.reports[0]
		XCTAssertEqual(actWeeklyReport.reports.count, 1)
		XCTAssertEqual(actDailyReport, newReport)
	}
	
	func test_updateReport_forExistingReports_shouldReturnMergedReportsForExistingReportsAndNewOne() throws {
		let startDayOfWeek = Date().getLastWeekday(weekday: .sunday)
		let existingWeeklyReport = WeeklyReport(startDayOfWeek: startDayOfWeek, reports: [
			DailyReport(startDayOfWeek: startDayOfWeek, weekDay: .sunday, duration: 10),
			DailyReport(startDayOfWeek: startDayOfWeek, weekDay: .monday, duration: 20)
		])
		let beforeUpdate = try JSONEncoder().encode(AllReport(reports: [existingWeeklyReport]))
		let newReport = DailyReport(startDayOfWeek: startDayOfWeek, weekDay: .tuesday, duration: 100)
		
		let updatedData = try sut.updateReport(beforeUpdate: beforeUpdate, targetWeek: startDayOfWeek, newReport: newReport)
		let act = try JSONDecoder().decode(AllReport.self, from: updatedData)
		
		let actWeeklyReport = act.reports[0].reports
		XCTAssertEqual(actWeeklyReport.count, existingWeeklyReport.reports.count + 1)
		for r in existingWeeklyReport.reports {
			XCTAssertTrue(actWeeklyReport.contains { $0 == r })					// check for existing reports
		}
		XCTAssertTrue(actWeeklyReport.contains { $0 == newReport })		// check for new report
	}
	
	func test_addReport_shouldAddNewReportToPersistenceData() throws {
		let startDayOfWeek = Date().getLastWeekday(weekday: .sunday)
		let newReport1 = DailyReport(startDayOfWeek: startDayOfWeek, weekDay: .sunday, duration: 10)
		let newReport2 = DailyReport(startDayOfWeek: startDayOfWeek, weekDay: .monday, duration: 20)
		let newReports = [newReport1, newReport2]
		let newReport1Encoded = try JSONEncoder().encode(newReport1)
		let newReport2Encoded = try JSONEncoder().encode(newReport2)
		
		try sut.addReport(newReportData: newReport1Encoded)
		try sut.addReport(newReportData: newReport2Encoded)
		
		let actual = try sut.loadReport()
		
		XCTAssertNotNil(actual)
		let reportsDecoded = try JSONDecoder().decode(AllReport.self, from: actual!)
		let weeklyReports = reportsDecoded.reports.first
		XCTAssertNotNil(weeklyReports)
		let reports = weeklyReports!.reports
		XCTAssertEqual(reports.count, newReports.count)
		for report in reports {
			XCTAssertTrue(newReports.contains(where: { $0 == report }))
		}
			
	}
	
}
