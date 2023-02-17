//
//  FakeDefaultUsers.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-31.
//

@testable import EyeDamage
import Foundation

class FakeUserDefaults: UserDefaultsProtocol {
	
	var store: [String: Any] = [:]
	
	func object(forKey defaultName: String) -> Any? {
		if let obj = store[defaultName] {
			return obj
		}
		
		return nil
	}
	
	func set(_ value: Any?, forKey defaultName: String) {
		store[defaultName] = value
	}
	
	func value(forKey key: String) -> Any? {
		if let val = store[key] {
			return val
		}
		
		return nil
	}
	
}
