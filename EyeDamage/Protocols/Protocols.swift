//
//  Protocols.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2023-01-31.
//

import Foundation

protocol URLSessionProtocol {
	func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

protocol FileManagerProtocol {
	func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
}

protocol UserDefaultsProtocol {
	func object(forKey defaultName: String) -> Any?
	func set(_ value: Any?, forKey defaultName: String)
	func value(forKey key: String) -> Any?
}

extension URLSession: URLSessionProtocol {}
extension FileManager: FileManagerProtocol {}
extension UserDefaults: UserDefaultsProtocol {}
