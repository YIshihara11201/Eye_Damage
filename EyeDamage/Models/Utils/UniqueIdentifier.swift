//
//  UniqueIdentifier.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-25.
//

import Foundation
import UIKit

struct UniqueIdentifier {
	
	static let uuidKey = "com.yusuke.eyedamageapp.unique_uuid"
	
	static func getUUID() -> String {
		let keychain = KeychainAccess()
		if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey) {
			return uuid
		}
		let newId = UIDevice.current.identifierForVendor!.uuidString
		try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)
		
		return newId
	}
	
	static func hasUUID() -> Bool {
		let uuidKey = uuidKey
		var key: String? = nil
		do {
			key = try KeychainAccess().queryKeychainData(itemKey: uuidKey)
		} catch {
			fatalError("\(error), \(error.localizedDescription)")
		}
		
		return key != nil
	}
	
}
