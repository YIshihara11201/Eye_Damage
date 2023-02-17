//
//  DataWrapper.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2023-01-30.
//

import Foundation

protocol DataHandlerProtocol {
	func write(data: Data, url: URL, options: Data.WritingOptions) throws
	func data(contentsOf url: URL) throws -> Data?
	func fileExists(atPath path: String) -> Bool
}

class DataHandler: DataHandlerProtocol {
	
	func write(data: Data, url: URL, options: Data.WritingOptions) throws {
		try data.write(to: url, options: options)
	}
	
	func data(contentsOf url: URL) throws -> Data? {
		return try Data(contentsOf: url)
	}
	
	func fileExists(atPath path: String) -> Bool {
		return FileManager.default.fileExists(atPath: path)
	}
	
}
