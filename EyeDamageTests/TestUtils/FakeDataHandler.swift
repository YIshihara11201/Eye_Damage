//
//  FakeDataHandler.swift
//  EyeDamageTests
//
//  Created by Yusuke Ishihara on 2023-01-30.
//

@testable import EyeDamage
import Foundation

class FakeDataHandler: DataHandlerProtocol {

	var files: [String: Data] = [:]
	
	func write(data: Data, url: URL, options: Data.WritingOptions) throws {
		files[url.absoluteString] = data
	}
	
	func data(contentsOf url: URL) throws -> Data? {
		return files[url.absoluteString]
	}
	
	func fileExists(atPath path: String) -> Bool {
		return files[path] != nil
	}
	
}
