//
//  SmartphoneTimeDetails.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-26.
//

import Foundation

struct SmartphoneTimeDetails {
	private let encoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		return encoder
	}()
	
	let deviceId: String
	let recordDate: Date
	let start: Date?
	let end: Date?
	let debug: Bool
	
	init(deviceId: String, recordDate: Date, start: Date? = nil, end: Date? = nil) {
		self.deviceId = deviceId
		self.recordDate = recordDate
		self.start = start
		self.end = end
		
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

extension SmartphoneTimeDetails: Encodable {
	private enum CodingKeys: CodingKey {
		case deviceId, recordDate ,start, end, debug
	}
}

extension SmartphoneTimeDetails: CustomStringConvertible {
	var description: String {
		return String(data: encoded(), encoding: .utf8) ?? "Invalid smartphone time"
	}
}
