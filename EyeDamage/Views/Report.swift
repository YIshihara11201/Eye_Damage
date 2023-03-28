//
//  Report.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-20.
//

import SwiftUI

struct Report: View {
    @Environment(\.scenePhase) private var scenePhase
	@State var firstWeekDay = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date().getLastWeekday(weekday: .sunday))!
	
	var body: some View {
		var allReports = ReportManager.getAllReports()
		var weekReport = ReportManager.getWeeklyReports(allReport: allReports, firstWeekDay: firstWeekDay)
		
		GeometryReader {
			geometry in
			VStack {
				Text("Weekly Report")
					.font(.custom("Manrope", size: 40) .bold())
					.foregroundColor(.black)
					.padding(.top, 30.0)
				
				HStack(alignment: .center){
					Button(action: {
						firstWeekDay = Calendar.current.date(byAdding: .day, value: -7, to: firstWeekDay)!
					}, label: {
						VStack(alignment: .trailing) {
							Image(systemName: "arrow.left")
								.font(.system(size: 25))
						}
						.frame(height: 50)
						.padding(.leading, 30)
					})
					.disabled(allReports == nil || !(allReports != nil && allReports!.oldestDate() < firstWeekDay))
					
					Spacer()
					
					Text("\(DateFormatter.yyyymmddFormatter().string(from: firstWeekDay)) ~ \(DateFormatter.mmddFormatter().string(from: firstWeekDay.sixDaysAgo()))")
						.font(.custom("Manrope", size: 20))
						.foregroundColor(.black)
					
					Spacer()
					
					Button(action: {
						firstWeekDay = Calendar.current.date(byAdding: .day, value: 7, to: firstWeekDay)!
					}, label: {
						VStack(alignment: .trailing) {
							Image(systemName: "arrow.right")
								.font(.system(size: 25))
						}
						.frame(height: 50)
						.padding(.trailing, 30)
					})
					.disabled(allReports == nil || !(firstWeekDay <= Calendar.current.date(byAdding: .day, value: -7, to: Date())!.getLastWeekday(weekday: .sunday).midnight()))
				}
				
				VStack(alignment: .leading, spacing: -5) {
					let rowHeight = geometry.size.height / CGFloat(weekReport.reports.count)*0.6
					let labelWidth = geometry.size.width * 0.1
					let graphWidth = geometry.size.width * 0.8
					let valueWidth = geometry.size.width * 0.1
					
					ForEach(weekReport.reports) { report in
						HStack {
							Text(report.weekDay.rawValue)
								.font(.custom("Manrope", size: 18))
								.foregroundColor(.black)
								.frame(maxWidth: labelWidth, maxHeight: .infinity, alignment: .center)
							
							let rowWidth = calculateRowWidth(graphWidth, report, weekReport)
							
							Rectangle()
								.cornerRadius(5)
								.padding(.vertical, 5)
								.padding(.horizontal, 10)
								.frame(maxWidth: .infinity)
								.frame(maxWidth: rowWidth, maxHeight: 30, alignment: .leading)
								.foregroundColor(Color.blue)
							
							if report.duration > 0 {
								Text("\(report.duration/60) min \(report.duration%60) sec")
									.font(.custom("Manrope", size: 8))
									.foregroundColor(.black)
									.frame(maxWidth: valueWidth, maxHeight: .infinity, alignment: .leading)
							}
						}
						.padding(.horizontal)
						.frame(maxHeight: rowHeight)
					}
					
					Spacer()
					
					HStack(alignment: .bottom) {
						Text("Total: \(weekReport.getWeeklyDuration()/60) min \(weekReport.getWeeklyDuration()%60) sec")
							.font(.custom("Manrope", size: 20))
							.foregroundColor(.black)
							.frame(maxWidth: .infinity, alignment: .trailing)
							.padding(.trailing, 30)
							.padding(.top, 20)
					}
					Spacer()
				}
				.padding(.vertical)
			}
			.frame(alignment: .center)
			.padding(10)
		}
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                allReports = ReportManager.getAllReports()
                weekReport = ReportManager.getWeeklyReports(allReport: allReports, firstWeekDay: firstWeekDay)
            }
        }
	}
	
	func calculateRowWidth(_ graphWidth: Double, _ dailyReport: DailyReport, _ weeklyReport: WeeklyReport) -> Double {
		let size = Double(dailyReport.duration) / Double(weeklyReport.longestDuration()) * graphWidth
		return size.isNaN ? 0.0 : size
	}
}

struct Report_Previews: PreviewProvider {
	static var previews: some View {
		Report()
	}
}
