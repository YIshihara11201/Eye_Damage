//
//  RequestsTests.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-30.
//

@testable import EyeDamage
import XCTest

final class RequestsTests: XCTestCase {
	private let sut = Requests.shared
	
	override func setUpWithError() throws {
		try super.setUpWithError()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
	
	func test_buildTokenRequest_requestDestinationIsCorrect() throws {
		let actual  = sut.buildTokenRequest(pushToken: nil, activityToken: nil)
		
		XCTAssertEqual(actual.url?.absoluteString, sut.tokenUrlString)
	}
	
	func test_buildSmartPhoneTimeRequest_forCreate_requestDestinationIsCorrect() throws {
		let recordDate = Date()
		let actual  = sut.buildSmartphoneTimeRequest(recordDate: recordDate, requestType: .create)
		
		XCTAssertEqual(actual.url?.absoluteString, sut.smartphoneTimeUrlString)
	}
	
	func test_buildSmartPhoneTimeRequest_forUpdate_requestDestinationIsCorrect() throws {
		let recordDate = Date()
		let actual  = sut.buildSmartphoneTimeRequest(recordDate: recordDate, requestType: .update)
		
		XCTAssertEqual(actual.url?.absoluteString, sut.smartphoneTimeUrlString + "/update")
	}
	
	func test_buildReportRequest_forCreate_requestDestinationIsCorrect() throws {
		let recordDate = Date()
		let actual  = sut.buildReportRequest(recordDate: recordDate, requestType: .create)
		
		XCTAssertEqual(actual.url?.absoluteString, sut.reportUrlString)
	}
	
	func test_buildReportRequest_forUpdate_requestDestinationIsCorrect() throws {
		let recordDate = Date()
		let actual  = sut.buildReportRequest(recordDate: recordDate, requestType: .fetchDaily)
		
		XCTAssertEqual(actual.url?.absoluteString, sut.reportUrlString + "/daily")
	}
	
}
