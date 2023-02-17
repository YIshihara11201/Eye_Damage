//
//  TokenDetails.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-23.
//

import Foundation

struct TokenDetails {
	private let encoder = JSONEncoder()
	
	let deviceId: String
	let pushToken: String?
	let activityToken: String?
	let debug: Bool
	
	init(deviceId: String, pushToken: Data?=nil, activityToken: Data?=nil) {
		self.deviceId = deviceId
		
		if let pushToken = pushToken {
			self.pushToken = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
		} else {
			self.pushToken = nil
		}
		
		if let activityToken = activityToken {
			self.activityToken = activityToken.reduce("") { $0 + String(format: "%02x", $1) }
		} else {
			self.activityToken = nil
		}
		
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

extension TokenDetails: Encodable {
	private enum CodingKeys: CodingKey {
		case deviceId, pushToken, activityToken, debug
	}
}

extension TokenDetails: CustomStringConvertible {
	var description: String {
		return String(data: encoded(), encoding: .utf8) ?? "Invalid token"
	}
}
