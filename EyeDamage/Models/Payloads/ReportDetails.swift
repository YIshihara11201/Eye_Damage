//
//  ReportDetails.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-26.
//

import Foundation

struct ReportDetails {
	private let encoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		return encoder
	}()
	
	let deviceId: String
	let startDayOfWeek: Date
	let recordDate: Date
	let duration: Int
	let debug: Bool
	
	init(deviceId: String, startDayOfWeek:Date, recordDate: Date, duration: Int) {
		self.deviceId = deviceId
		self.startDayOfWeek = startDayOfWeek
		self.recordDate = recordDate
		self.duration = duration
		
#if DEBUG
		encoder.outputFormatting = .prettyPrinted
		debug = true
#else
		debug = false
#endif
	}
	
	func encoded() -> Data {
		return try! encoder.encode(self)
	}
	
}

extension ReportDetails: Encodable {
	private enum CodingKeys: CodingKey {
		case deviceId, startDayOfWeek ,recordDate, duration, debug
	}
}

extension ReportDetails: CustomStringConvertible {
	var description: String {
		return String(data: encoded(), encoding: .utf8) ?? "Invalid report"
	}
}
