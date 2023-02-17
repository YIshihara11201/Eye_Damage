//
//  FakeFileManager.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-30.
//

@testable import EyeDamage
import Foundation

class FakeFileManager: FileManagerProtocol {
	func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
		let dummyPathStr = "dummy"
		
		return [URL(string: dummyPathStr)!]
	}
	
}
