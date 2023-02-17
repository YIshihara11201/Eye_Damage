//
//  FakeURLSession.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-30.
//

@testable import EyeDamage
import XCTest

class FakeURLSession: URLSessionProtocol {
	
	func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
		let dummyData = Data()
		let dummyURLResponse = URLResponse()
		
		return (dummyData, dummyURLResponse)
	}
	
}
