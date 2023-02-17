//
//  AppStateViewModelTests.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-31.
//

@testable import EyeDamage
import XCTest

final class AppStateViewModelTests: XCTestCase {
	
	private var sut: AppStateViewModel!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = AppStateViewModel()
		sut.userDefaults = FakeUserDefaults()
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func test_toggleReceivedNotification_currentStateIsFalse_shouldTogglePropertyAndPersistanceData() {
		sut.receivedNotification = false
		
		sut.toggleReceivedNotification()
		
		let actReceivedNotificationState = sut.receivedNotification
		let actUserDefaultsReceivedNotification = sut.userDefaults.value(forKey: sut.userDefaultObjectKeyReceivedNotification)
		
		XCTAssertTrue(actReceivedNotificationState)
		XCTAssertTrue(actUserDefaultsReceivedNotification as! Bool)
	}
	
	func test_toggleReceivedNotification_currentStateIsTrue_shouldTogglePropertyAndPersistanceData() {
		sut.receivedNotification = true
		
		sut.toggleReceivedNotification()
		
		let actReceivedNotificationState = sut.receivedNotification
		let actUserDefaultsReceivedNotification = sut.userDefaults.value(forKey: sut.userDefaultObjectKeyReceivedNotification)
		
		XCTAssertFalse(actReceivedNotificationState)
		XCTAssertFalse(actUserDefaultsReceivedNotification as! Bool)
	}
	
	func test_toggleReceiveDailyReportState_currentStateIsFalse_shouldTogglePropertyAndPersistanceData() {
		sut.receivedDailyReport = false
		
		sut.toggleReceiveDailyReportState()
		
		let actReceivedDailyReport = sut.receivedDailyReport
		let actUserDefaultsReceivedDailyReport = sut.userDefaults.value(forKey: sut.userDefaultObjectKeyReceivedDailyReport)
		
		XCTAssertTrue(actReceivedDailyReport)
		XCTAssertTrue(actUserDefaultsReceivedDailyReport as! Bool)
	}
	
	func test_toggleReceiveDailyReportState_currentStateIsTrue_shouldTogglePropertyAndPersistanceData() {
		sut.receivedDailyReport = true
		
		sut.toggleReceiveDailyReportState()
		
		let actReceivedDailyReport = sut.receivedDailyReport
		let actUserDefaultsReceivedDailyReport = sut.userDefaults.value(forKey: sut.userDefaultObjectKeyReceivedDailyReport)
		
		XCTAssertFalse(actReceivedDailyReport)
		XCTAssertFalse(actUserDefaultsReceivedDailyReport as! Bool)
	}
	
	func test_toggleLockRequestSent_currentStateIsFalse_shouldTogglePropertyAndPersistanceData() {
		sut.lockRequestSent = false
		
		sut.toggleLockRequestSent()
		
		let actLockRequestSent = sut.lockRequestSent
		let actUserDefaultsLockRequestSent = sut.userDefaults.value(forKey: sut.userDefaultObjectKeyLockRequestSent)
		
		XCTAssertTrue(actLockRequestSent)
		XCTAssertTrue(actUserDefaultsLockRequestSent as! Bool)
	}
	
	func test_toggleLockRequestSent_currentStateIsTrue_shouldTogglePropertyAndPersistanceData() {
		sut.lockRequestSent = true
		
		sut.toggleLockRequestSent()
		
		let actLockRequestSent = sut.lockRequestSent
		let actUserDefaultsLockRequestSent = sut.userDefaults.value(forKey: sut.userDefaultObjectKeyLockRequestSent)
		
		XCTAssertFalse(actLockRequestSent)
		XCTAssertFalse(actUserDefaultsLockRequestSent as! Bool)
	}

}
