//
//  TimerViewModelTests.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-30.
//

@testable import EyeDamage
import XCTest

final class TimerViewModelTests: XCTestCase {
	
	private var sut: TimerViewModel!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = TimerViewModel()
		sut.userDefaults = FakeUserDefaults()
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func test_getInitialBedtime_currentTimeIsBefore0AM_shouldReturn10PM() throws {
		let currentDate = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
		let currYear = Calendar.current.component(.year, from: currentDate)
		let currMonth = Calendar.current.component(.month, from: currentDate)
		let currDay = Calendar.current.component(.day, from: currentDate)
		
		let actual = sut.getInitialBedtime(currentDate: currentDate)
		let actYear = Calendar.current.component(.year, from: actual)
		let actMonth = Calendar.current.component(.month, from: actual)
		let actDay = Calendar.current.component(.day, from: actual)
		let actHour = Calendar.current.component(.hour, from: actual)
		let actMinute = Calendar.current.component(.minute, from: actual)
		
		XCTAssertEqual(actYear, currYear)
		XCTAssertEqual(actMonth, currMonth)
		XCTAssertEqual(actDay, currDay)
		XCTAssertEqual(actHour, 22)
		XCTAssertEqual(actMinute, 0)
	}
	
	func test_getInitialBedtime_currentTimeIsBetween0AMAnd3AM_shouldReturnOneMinuteAfterNow() throws {
		let currentDate = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: Date())!
		let currYear = Calendar.current.component(.year, from: currentDate)
		let currMonth = Calendar.current.component(.month, from: currentDate)
		let currDay = Calendar.current.component(.day, from: currentDate)
		let currHour = Calendar.current.component(.hour, from: currentDate)
		let currMinute = Calendar.current.component(.minute, from: currentDate)
		
		let actual = sut.getInitialBedtime(currentDate: currentDate)
		let actYear = Calendar.current.component(.year, from: actual)
		let actMonth = Calendar.current.component(.month, from: actual)
		let actDay = Calendar.current.component(.day, from: actual)
		let actHour = Calendar.current.component(.hour, from: actual)
		let actMinute = Calendar.current.component(.minute, from: actual)
		
		XCTAssertEqual(actYear, currYear)
		XCTAssertEqual(actMonth, currMonth)
		XCTAssertEqual(actDay, currDay)
		XCTAssertEqual(actHour, actMinute==59 ? currHour+1 : currHour)
		XCTAssertEqual(actMinute, actMinute==59 ? 0 : currMinute+1)
	}
	
	func test_getInitialWakeupTime_currentTimeIsBefore0AM_shouldReturnDate7HoursAfterBedtime() throws {
		let currentDate = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
		let bedTime = sut.getInitialBedtime(currentDate: currentDate)
		
		let actual = sut.getInitialWakeUp(currendDate: currentDate)
		
		XCTAssertEqual(DateInterval(start: bedTime, end: actual).duration, 7*60*60) // 7 hours
	}
	
	func test_getInitialWakeupTime_currentTimeIsBetween0AMAnd3AM_shouldReturnDate7HoursAfterBedtime() throws {
		let currentDate = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: Date())!
		let bedTime = sut.getInitialBedtime(currentDate: currentDate)
		
		let actual = sut.getInitialWakeUp(currendDate: currentDate)
		
		XCTAssertEqual(DateInterval(start: bedTime, end: actual).duration, 7*60*60) // 7 hours
	}
	
	func test_getBedtimeForToday_previousBedTimeIsOfLastDay_shouldReturnDateForTodayAtSameTime() throws {
		let expectedBedtime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
		let lastBedTime = Calendar.current.date(byAdding: .day, value: -1, to: expectedBedtime)!
		sut.bedtime = lastBedTime
		
		let actual = sut.getBedtimeForToday()
		
		XCTAssertEqual(actual, expectedBedtime)
	}
	
	func test_getBedtimeForToday_previousBedTimeIsOfTwoDaysAgo_shouldReturnDateForTodayAtSameTime() throws {
		let expectedBedtime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
		let lastBedTime = Calendar.current.date(byAdding: .day, value: -2, to: expectedBedtime)!
		sut.bedtime = lastBedTime
		
		let actual = sut.getBedtimeForToday()
		
		XCTAssertEqual(actual, expectedBedtime)
	}
	
	func test_getWakeUpTimeForTomorrow_previousWakeupTimeIsOfToday_shouldReturnDateForTomorrowAtSameTime() throws {
		let lastWakeupTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
		let expectedWakeupTime = Calendar.current.date(byAdding: .day, value: 1, to: lastWakeupTime)
		sut.wakeUp = expectedWakeupTime
		
		let actual = sut.getWakeUpTimeForTomorrow()
		
		XCTAssertEqual(actual, expectedWakeupTime)
	}
	
	func test_getWakeUpTimeForTomorrow_previousWakeupTimeIsOfOneDayAgo_shouldReturnDateForTomorrowAtSameTime() throws {
		let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
		let lastWakeupTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: yesterDay)!
		let expectedWakeupTime = Calendar.current.date(byAdding: .day, value: 2, to: lastWakeupTime)
		sut.wakeUp = expectedWakeupTime
		
		let actual = sut.getWakeUpTimeForTomorrow()
		
		XCTAssertEqual(actual, expectedWakeupTime)
	}
	
	func test_getLiveActivityEndTime_previousWakeupTimeIsOfOneDayAgo_shouldReturnDateForTomorrowAtSameTime() throws {
		let bedTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
		var expectedLiveActivityEndTime = Calendar.current.date(byAdding: .hour, value: 7, to: bedTime)!
		expectedLiveActivityEndTime = Calendar.current.date(byAdding: .minute, value: 56, to: expectedLiveActivityEndTime)!
		sut.bedtime = bedTime
		
		let actual = sut.getLiveActivityEndTime()
		
		XCTAssertEqual(actual, expectedLiveActivityEndTime)
	}
	
	func test_storeTimer_shouldUpdatePersistenceBedtimeAndWakeupTime() {
		let bedTime = sut.bedtime
		let wakeupTime = sut.wakeUp
		
		sut.storeTimer()
		
		XCTAssertEqual((sut.userDefaults.value(forKey: sut.userDefaultObjectKeyForBedtime) as! Date), bedTime)
		XCTAssertEqual((sut.userDefaults.value(forKey: sut.userDefaultObjectKeyForWakeUp) as! Date), wakeupTime)
	}
	
	func test_hasStoredTimer_withNoStoredDate_shouldReturnFalse() {
		let actual = sut.hasStoredTimer()
		
		XCTAssertFalse(actual)
	}
	
	func test_hasStoredTimer_withHasStoredDate_shouldReturnTrue() {
		sut.storeTimer()
		
		let actual = sut.hasStoredTimer()
		
		XCTAssertTrue(actual)
	}
	
	func test_shiftOnedayAhead_shouldShiftOnedayAheadPropertyDateAndPersistenceDate() {
		let initialBedTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
		var initialWakeupTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
		initialWakeupTime = Calendar.current.date(byAdding: .day, value: 1, to: initialWakeupTime)!
		let expectedBedTime = Calendar.current.date(byAdding: .day, value: 1, to: initialBedTime)!
		let expectedWakeupTime = Calendar.current.date(byAdding: .day, value: 1, to: initialWakeupTime)!
		
		sut.bedtime = initialBedTime
		sut.wakeUp = initialWakeupTime
		
		sut.shiftOnedayAhead()
		
		XCTAssertEqual(sut.bedtime, expectedBedTime)
		XCTAssertEqual(sut.wakeUp, expectedWakeupTime)
		XCTAssertEqual(sut.userDefaultsBedtime, expectedBedTime)
		XCTAssertEqual(sut.userDefaultsWakeUp, expectedWakeupTime)
	}
	
	func test_getBedtimeRange_currentTimeIsBetween0AMAnd3AM_shouldReturnRangeOf21PMto3AM() {
		let currDate = Calendar.current.date(bySettingHour: 1, minute: 0, second: 0, of: Date())!
		var expectedLowerBoundary = Calendar.current.date(byAdding: .day, value: -1, to: currDate)!
		expectedLowerBoundary = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: expectedLowerBoundary)!
		let expectedUpperBoundary = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: currDate)!
		
		let res = sut.getBedtimeRange(currentDate: currDate)
		
		XCTAssertEqual(res, expectedLowerBoundary...expectedUpperBoundary)
	}
	
	func test_getBedtimeRange_currentTimeIsBefore0AM_shouldReturnRangeOf21PMto3AMStartingFromTheDay() {
		let currDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
		let expectedLowerBoundary = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: currDate)!
		var expectedUpperBoundary = Calendar.current.date(byAdding: .day, value: 1, to: expectedLowerBoundary)!
		expectedUpperBoundary = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: expectedUpperBoundary)!
		
		let res = sut.getBedtimeRange(currentDate: currDate)
		
		XCTAssertEqual(res, expectedLowerBoundary...expectedUpperBoundary)
	}
	
	func test_getBedtimeRange_currentTimeIsAfter3AM_shouldReturnRangeOf21PMto3AMStartingFromTheDay() {
		let currDate = Date()
		let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currDate)!
		let expectedLowerBoundary = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: currDate)!
		var expectedUpperBoundary = Calendar.current.date(byAdding: .day, value: 1, to: expectedLowerBoundary)!
		expectedUpperBoundary = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: nextDay)!
		
		let res = sut.getBedtimeRange(currentDate: currDate)
		
		XCTAssertEqual(res, expectedLowerBoundary...expectedUpperBoundary)
	}
	
	func test_getBedtimeRange_currentTimeIs0AM_shouldReturnRangeOf21PMto3AMStartingFromPreviousDay() {
		let currDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
		var expectedLowerBoundary = Calendar.current.date(byAdding: .day, value: -1, to: currDate)!
		expectedLowerBoundary = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: expectedLowerBoundary)!
		let expectedUpperBoundary = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: currDate)!
		
		let res = sut.getBedtimeRange(currentDate: currDate)
		
		XCTAssertEqual(res, expectedLowerBoundary...expectedUpperBoundary)
	}
	
	func test_getBedtimeRange_currentTimeIs3AM_shouldReturnRangeOf21PMto3AMStartingFromPreviousDay() {
		let currDate = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: Date())!
		var expectedLowerBoundary = Calendar.current.date(byAdding: .day, value: -1, to: currDate)!
		expectedLowerBoundary = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: expectedLowerBoundary)!
		let expectedUpperBoundary = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: currDate)!
		
		let res = sut.getBedtimeRange(currentDate: currDate)
		
		XCTAssertEqual(res, expectedLowerBoundary...expectedUpperBoundary)
	}
	
	func test_getWakeupTimeRange_bedTimeIsBefore0AM_shouldReturnRangeOf5hoursAnd11HoursAfterBedtime() {
		let currDate = Date()
		let bedTime = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: currDate)!
		sut.bedtime = bedTime
		let expectedLowerBoundary = Calendar.current.date(byAdding: .hour, value: 5, to: bedTime)!
		let expectedUpperBoundary = Calendar.current.date(byAdding: .hour, value: 11, to: bedTime)!
		
		let actual = sut.getWakeupTimeRange()
		
		XCTAssertEqual(actual, expectedLowerBoundary...expectedUpperBoundary)
	}
	
	func test_getWakeupTimeRange_bedTimeIsAfter0AM_shouldReturnRangeOf5hoursAnd11HoursAfterBedtime() {
		let currDate = Date()
		let bedTime = Calendar.current.date(bySettingHour: 1, minute: 0, second: 0, of: currDate)!
		sut.bedtime = bedTime
		let expectedLowerBoundary = Calendar.current.date(byAdding: .hour, value: 5, to: bedTime)!
		let expectedUpperBoundary = Calendar.current.date(byAdding: .hour, value: 11, to: bedTime)!
		
		let actual = sut.getWakeupTimeRange()
		
		XCTAssertEqual(actual, expectedLowerBoundary...expectedUpperBoundary)
	}
	
}
