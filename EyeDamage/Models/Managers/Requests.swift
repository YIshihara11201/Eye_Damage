//
//  Requests.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-26.
//

import Foundation

enum SmartphoneTimeRequestType { case create; case update }
enum ReportRequestType { case create; case fetchDaily; }

struct Requests {
	static let shared = Requests()
	
	var urlSession: URLSessionProtocol = URLSession.shared
	
	let tokenUrlString = "https://eyedamage-backend.herokuapp.com/token"
	let smartphoneTimeUrlString = "https://eyedamage-backend.herokuapp.com/phone"
	let reportUrlString = "https://eyedamage-backend.herokuapp.com/report"
	
	@discardableResult
	func send(request: URLRequest) async throws -> (Data, URLResponse) {
		//		let res = try await URLSession.shared.data(for: request)
		let res = try await urlSession.data(for: request, delegate: nil)
		
		return res
	}
	
	func buildTokenRequest(pushToken: Data?, activityToken: Data?) -> URLRequest {
		guard let tokenUrl = URL(string: tokenUrlString) else { fatalError("Invalid URL string") }
		
		var request = URLRequest(url: tokenUrl)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		request.httpBody = TokenDetails(deviceId: UniqueIdentifier.getUUID(), pushToken: pushToken, activityToken: activityToken).encoded()
		
		return request
	}
	
	func buildSmartphoneTimeRequest(recordDate: Date, start: Date? = nil, end: Date? = nil, requestType: SmartphoneTimeRequestType) -> URLRequest {
		var url: URL
		switch requestType {
		case .create:
			guard let smartphoneTimeUrl = URL(string: smartphoneTimeUrlString) else { fatalError("Invalid URL string") }
			url = smartphoneTimeUrl
		case .update:
			guard let smartphoneTimeUrl = URL(string: smartphoneTimeUrlString + "/update") else { fatalError("Invalid URL string") }
			url = smartphoneTimeUrl
		}
		
		var request = URLRequest(url: url)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		request.httpBody = SmartphoneTimeDetails(deviceId: UniqueIdentifier.getUUID(), recordDate: recordDate, start: start, end: end).encoded()
		
		return request
	}
	
	func buildReportRequest(recordDate: Date, requestType: ReportRequestType) -> URLRequest {
		var url: URL
		switch requestType {
		case .create:
			guard let reportUrl = URL(string: reportUrlString) else { fatalError("Invalid URL string") }
			url = reportUrl
		case .fetchDaily:
			guard let reportUrl = URL(string: reportUrlString + "/daily") else { fatalError("Invalid URL string") }
			url = reportUrl
		}
		
		var startDayOfWeek = recordDate.getLastWeekday(weekday: .sunday)
		startDayOfWeek = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDayOfWeek)!
		var request = URLRequest(url: url)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		request.httpBody = ReportDetails(deviceId: UniqueIdentifier.getUUID(), startDayOfWeek: startDayOfWeek, recordDate: recordDate, duration: 0).encoded()
		
		return request
	}
	
}
