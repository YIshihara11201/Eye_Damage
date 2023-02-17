//
//  ContentView.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-18.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
	@EnvironmentObject var timerVM: TimerViewModel
	@EnvironmentObject var appStateVM: AppStateViewModel
	@State private var selection = 1
	
	let willUnlockNotification = NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)
	let willEnterForegroundNotification = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
	
	init() {
		UITabBar.appearance().isTranslucent = false
		UITabBar.appearance().barTintColor = UIColor(named: "Secondary")
	}
	
	var body: some View {
		TabView(selection: $selection) {
			Setting()
				.background(Color("ImageColor"))
				.tabItem {
					Image(systemName: "clock")
					Text("Setting")
				}
				.tag(1)
			
			Report()
				.background(Color("ImageColor"))
				.tabItem {
					Image(systemName: "doc")
					Text("Report")
				}
				.tag(2)
		}
		.background(Color.white)
		.onOpenURL(perform: { url in
			if url.absoluteString == "1" {
				selection = 1
			} else if url.absoluteString == "2" {
				selection = 2
			}
		}).onReceive(willUnlockNotification, perform: { _ in
			if appStateVM.lockRequestSent {
				appStateVM.toggleLockRequestSent()
				
				let currDate = Date()
				let recordDate = currDate.midnight()
				if appStateVM.receivedNotification
						&& currDate >= timerVM.bedtime
						&& currDate < timerVM.getLiveActivityEndTime() {
					Task {
						let smartphoneTimeRequest = Requests.shared.buildSmartphoneTimeRequest(
							recordDate: recordDate,
							start: currDate,
							end: nil,
							requestType: .create)
						try await Requests.shared.send(request: smartphoneTimeRequest)
					}
				}
			}
		})
		.onReceive(willEnterForegroundNotification, perform: { _ in
			// get report when users open application for the first time for a day
			let currDate = Date()
			if timerVM.hasStoredTimer()
					&& currDate >= timerVM.wakeUp
					&& appStateVM.receivedNotification
					&& !appStateVM.receivedDailyReport {
				
				Task {
					let recordDate = currDate.midnight()
					let reportRequest = Requests.shared.buildReportRequest(
						recordDate: recordDate,
						requestType: .fetchDaily)
					let (data, _) =	try await Requests.shared.send(request: reportRequest)
					try ReportManager.addReport(newReportData: data)
				}
				
				appStateVM.toggleReceivedNotification()
				appStateVM.toggleReceiveDailyReportState()
				if appStateVM.lockRequestSent {
					appStateVM.toggleLockRequestSent()
				}
				timerVM.shiftOnedayAhead()
			}
		})
	}
}

struct ContentView_Previews: PreviewProvider {	
	static var previews: some View {
		ContentView()
			.environmentObject(TimerViewModel())
			.environmentObject(AppStateViewModel())
	}
}
