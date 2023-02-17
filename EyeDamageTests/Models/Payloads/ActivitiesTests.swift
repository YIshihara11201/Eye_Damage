//
//  ActivitiesTests.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-30.
//

@testable import EyeDamage
import XCTest

final class ActivitiesTests: XCTestCase {
	private let sut = Activities.self
	
	override func setUpWithError() throws {
		try super.setUpWithError()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
	
	func test_sendTokenRequest() async throws {
		_ = XCTSkip("live activity's token cannot be set other than using network request, and this function is not testable")
	}
	
}
