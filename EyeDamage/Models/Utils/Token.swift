//
//  Token.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-23.
//

import Foundation

struct Token {
	static let userDefaultActivityTokenKey = "activity token"
	
	static func tokenString(token: Data) -> String {
		return token.map {String(format: "%02x", $0)}.joined()
	}
}
