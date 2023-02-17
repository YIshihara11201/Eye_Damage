//
//  Date+ExtensionsTests.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-29.
//

@testable import EyeDamage
import XCTest

final class Date_ExtensionsTests: XCTestCase {
	private var sut: Date!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = Date()
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func test_getLastWeekday_argumentIsMonday_shouldReturnLastMonday() throws {
		let calendar = Calendar.current
		let weekBefore = calendar.date(byAdding: .day, value: -7, to: Date())!
		var cmp = calendar.dateComponents([.hour, .minute, .second], from: Date())
		cmp.weekday = 1 // monday
		let lastMonday = calendar.nextDate(after: weekBefore, matching: cmp, matchingPolicy: .previousTimePreservingSmallerComponents)!
		let actYear = Calendar.current.dateComponents([.weekday, .weekOfYear], from: lastMonday).year
		let actMonth = Calendar.current.dateComponents([.weekday, .weekOfYear], from: lastMonday).month
		let actDay = Calendar.current.dateComponents([.weekday, .weekOfYear], from: lastMonday).day
		
		
		let actual = sut.getLastWeekday(weekday: .monday)
		let year = Calendar.current.dateComponents([.weekday, .weekOfYear], from: actual).year
		let month = Calendar.current.dateComponents([.weekday, .weekOfYear], from: actual).month
		let day = Calendar.current.dateComponents([.weekday, .weekOfYear], from: actual).day
		
		XCTAssertEqual(actYear, year)
		XCTAssertEqual(actMonth, month)
		XCTAssertEqual(actDay, day)
	}
	
	func test_getLastWeekday_argumentIsWednesday_shouldReturnLastWednesday() throws {
		let calendar = Calendar.current
		let weekBefore = calendar.date(byAdding: .day, value: -7, to: Date())!
		var cmp = calendar.dateComponents([.hour, .minute, .second], from: Date())
		cmp.weekday = 3 // wednesday
		let lastMonday = calendar.nextDate(after: weekBefore, matching: cmp, matchingPolicy: .previousTimePreservingSmallerComponents)!
		let actYear = Calendar.current.dateComponents([.weekday, .weekOfYear], from: lastMonday).year
		let actMonth = Calendar.current.dateComponents([.weekday, .weekOfYear], from: lastMonday).month
		let actDay = Calendar.current.dateComponents([.weekday, .weekOfYear], from: lastMonday).day
		
		let actual = sut.getLastWeekday(weekday: .wednesday)
		let year = Calendar.current.dateComponents([.weekday, .weekOfYear], from: actual).year
		let month = Calendar.current.dateComponents([.weekday, .weekOfYear], from: actual).month
		let day = Calendar.current.dateComponents([.weekday, .weekOfYear], from: actual).day
		
		XCTAssertEqual(actYear, year)
		XCTAssertEqual(actMonth, month)
		XCTAssertEqual(actDay, day)
	}
	
	func test_midnight_hourIsBetween3amTo2pm_shouldReturn0amForPreviousDate() {
		let calendar = Calendar.current
		sut = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date())
		
		let actual = sut.midnight()
		
		let lastDate = calendar.date(byAdding: .day, value: -1, to: sut)!
		let zeroAMForLastDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: lastDate)!
		XCTAssertEqual(actual, zeroAMForLastDate)
	}
	
	func test_midnight_hourIs2pm_shouldReturn0amForPreviousDate() {
		let calendar = Calendar.current
		sut = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: Date())
		
		let actual = sut.midnight()
		
		let lastDate = calendar.date(byAdding: .day, value: -1, to: sut)!
		let zeroAMForLastDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: lastDate)!
		XCTAssertEqual(actual, zeroAMForLastDate)
	}
	
	func test_midnight_hourIs3am_shouldReturn0amForPreviousDate() {
		let calendar = Calendar.current
		sut = calendar.date(bySettingHour: 3, minute: 0, second: 0, of: Date())
		
		let actual = sut.midnight()
		
		let lastDate = calendar.date(byAdding: .day, value: -1, to: sut)!
		let zeroAMForLastDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: lastDate)!
		XCTAssertEqual(actual, zeroAMForLastDate)
	}
	
	func test_midnight_hourIsOneSecondAfter14_shouldReturn0amForTheDay() {
		let calendar = Calendar.current
		sut = calendar.date(bySettingHour: 14, minute: 0, second: 1, of: Date())!
		
		let actual = sut.midnight()
		
		let zeroAMForToday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: sut)!
		XCTAssertEqual(actual, zeroAMForToday)
	}
	
	func test_midnight_hourIsBetweenAfter14And24_shouldReturn0amForTheDay() {
		let calendar = Calendar.current
		sut = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
		
		let actual = sut.midnight()
		
		let zeroAMForToday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: sut)!
		XCTAssertEqual(actual, zeroAMForToday)
	}
	
	func test_midnight_hourIsOneSecondBefore24_shouldReturn0amForTheDay() {
		let calendar = Calendar.current
		sut = calendar.date(bySettingHour: 23, minute: 59, second: 0, of: Date())!
		
		let actual = sut.midnight()
		
		let zeroAMForToday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: sut)!
		XCTAssertEqual(actual, zeroAMForToday)
	}
	
}
