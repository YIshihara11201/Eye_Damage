//
//  ReportManager.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-12-01.
//

import Foundation

struct ReportManager {
	static var fileManager: FileManagerProtocol = FileManager.default
	static var dataHandler: DataHandlerProtocol = DataHandler()
	
	static let fileName = "usageReport"
	static var encoder: JSONEncoder {
		let ecd = JSONEncoder()
		ecd.dateEncodingStrategy = .iso8601
		
		return ecd
	}
	
	static var decoder: JSONDecoder {
		let dcd = JSONDecoder()
		dcd.dateDecodingStrategy = .iso8601
		
		return dcd
	}
	
	static func hasFile(fileName: String) -> Bool {
		var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		url = url.appendingPathComponent("\(fileName)")
		url = url.appendingPathExtension("data")
		
		return dataHandler.fileExists(atPath: url.path())
	}
	
	static func loadReport() throws -> Data? {
		var data: Data? = nil
		
		if hasFile(fileName: fileName) {
			var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
			url = url.appendingPathComponent("\(fileName)")
			url = url.appendingPathExtension("data")
			
			data = try dataHandler.data(contentsOf: url)
		}
		
		return data
	}
	
	static func updateReport(beforeUpdate: Data, targetWeek: Date, newReport: DailyReport) throws -> Data {
		var res: Data
		var allReports = try decoder.decode(AllReport.self, from: beforeUpdate)
		
		if var currWeekReports = allReports.reports.first(where: { report in	// select target week from all reports
			report.startDayOfWeek == targetWeek
		}) {
			currWeekReports.reports.append(newReport)														// update weekly report
			allReports.reports.removeAll(where: { report in											// remove previous current week reports from whole reports
				report.startDayOfWeek == targetWeek
			})
			allReports.reports.append(currWeekReports)													// add updated current week reports
		} else {
			let newWeekReport = WeeklyReport(startDayOfWeek: targetWeek, reports: [newReport])
			allReports.reports.append(newWeekReport)
		}
		
		res = try encoder.encode(allReports)
		return res
	}
	
	static func addReport(newReportData: Data) throws {
		let newReport = try decoder.decode(DailyReport.self, from: newReportData)
						
		let firstDayOfWeek = newReport.startDayOfWeek
		let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
		var updatedReports: Data
		if let url = urls.first {
			var fileURL = url.appendingPathComponent(fileName)
			fileURL = fileURL.appendingPathExtension("data")
			
			if let loadedReport = try loadReport() {
				updatedReports = try updateReport(beforeUpdate: loadedReport, targetWeek: firstDayOfWeek, newReport: newReport)
			} else {
				let reports = AllReport(reports: [WeeklyReport(startDayOfWeek: firstDayOfWeek, reports: [newReport])])
				updatedReports = try encoder.encode(reports)
			}
			
			try dataHandler.write(data: updatedReports, url: fileURL, options: [.atomic])
		}
		
	}
	
	static func getAllReports() -> AllReport? {
		do {
			guard let data = try ReportManager.loadReport() else { return nil }
			let reports = try decoder.decode(AllReport.self, from: data)
			
			return reports
		} catch {
			print("\(error)")
			return nil
		}
	}
	
	static func getWeeklyReports(allReport: AllReport?, firstWeekDay: Date) -> WeeklyReport {
		var res: WeeklyReport
		if let aReport = allReport {
			res = aReport.getWeekReports(firstWeekDay: firstWeekDay)
		} else {
			res = WeeklyReport.emptyWeekReports(startDay: firstWeekDay)
		}
		
		return res
	}
	
}
