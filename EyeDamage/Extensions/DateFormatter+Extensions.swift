//
//  DateFormatter+Extensions.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2023-01-19.
//

import Foundation

extension DateFormatter {
	
	static func mmmdhhmmFormatter() -> DateFormatter {
		let fmt = DateFormatter()
		fmt.dateFormat = "MMM d, HH:mm"
		return fmt
	}
	
	static func yyyymmddFormatter() -> DateFormatter {
		let fmt = DateFormatter()
		fmt.dateFormat = "yyyy/MM/dd"
		return fmt
	}
	
	static func mmddFormatter() -> DateFormatter {
		let fmt = DateFormatter()
		fmt.dateFormat = "MM/dd"
		return fmt
	}
	
	static func hhmmFormatter() -> DateFormatter {
		let fmt = DateFormatter()
		fmt.dateFormat = "HH:mm"
		return fmt
	}
	
}
