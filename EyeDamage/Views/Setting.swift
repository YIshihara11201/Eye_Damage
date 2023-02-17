//
//  Setting.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-18.
//

import SwiftUI
import ActivityKit

struct Setting: View {
	@EnvironmentObject var timerVM: TimerViewModel
	@EnvironmentObject var appStateVM: AppStateViewModel
	
	var body: some View {
		GeometryReader {
			geometry in
			let stackHeight = geometry.size.height * 1.0
			let stackWidth = geometry.size.width * 1.0
			
			VStack(alignment: .center, spacing: 0) {
				if appStateVM.receivedNotification {
					Spacer()
					Text("Before Sleep,\nTap Sleep button!")
						.font(.custom("Manrope", size: 22))
						.foregroundColor(.black)
				}
				
				if let storedBedTime = timerVM.userDefaultsBedtime, Date() < storedBedTime, !appStateVM.receivedNotification {
					Spacer()
					Text("You will receive\nbedtime notification at \(DateFormatter.hhmmFormatter().string(from: storedBedTime))")
						.font(.custom("Manrope", size: 22))
						.foregroundColor(.black)
				}
				Spacer()
				
				Group {
					Image("sleeping")
						.resizable()
						.frame(width: 100, height: 100, alignment: .center)
					
					if !appStateVM.receivedNotification {
						DatePicker("bedtime", selection: $timerVM.bedtime, in: timerVM.getBedtimeRange(currentDate: Date()))
							.labelsHidden()
							.frame(maxWidth: .infinity)
					} else {
						Text("\(DateFormatter.mmmdhhmmFormatter().string(from: timerVM.userDefaultsBedtime != nil ? timerVM.userDefaultsBedtime!: timerVM.bedtime))")
							.font(.custom("Manrope", size: 20))
							.frame(alignment: .center)
							.padding(.top, 8)
					}
				}
				Spacer()
				
				Group {
					Image("wake-up")
						.resizable()
						.frame(width: 100, height: 100, alignment: .center)
						.padding(.bottom, 10)
					if !appStateVM.receivedNotification {
						DatePicker("wakeup", selection: $timerVM.wakeUp, in: timerVM.getWakeupTimeRange())
							.labelsHidden()
							.frame(maxWidth: .infinity)
					} else {
						Text("\(DateFormatter.mmmdhhmmFormatter().string(from: timerVM.userDefaultsWakeUp != nil ? timerVM.userDefaultsWakeUp!: timerVM.wakeUp))")
							.font(.custom("Manrope", size: 20))
							.frame(alignment: .center)
							.padding(.top, 8)
					}
					
				}
				Spacer()
				
				if appStateVM.receivedNotification {
					Button(action: {
						let currDate = Date()
						appStateVM.toggleLockRequestSent()
						
						if currDate < timerVM.getLiveActivityEndTime() {
							Task{
								let smartphoneTimeRequest = Requests.shared.buildSmartphoneTimeRequest(
									recordDate: currDate.midnight(),
									start: nil,
									end: currDate,
									requestType: .update)
								try await Requests.shared.send(request: smartphoneTimeRequest)
							}
						}
						
					}, label: {
						Text("Sleep")
							.font(.custom("Manrope", size: 22))
					})
					.buttonStyle(GrowingButton())
					.disabled(appStateVM.lockRequestSent == true)
				} else {
					Button(action: {
						timerVM.storeTimer()
						LocalNotification.shared.setLocalNotification(date: timerVM.bedtime)
					}, label: {
						Text("Set schedule")
							.font(.custom("Manrope", size: 22))
					})
					.buttonStyle(GrowingButton())
				}
				
				Spacer()
			}
			.padding(.horizontal)
			.frame(maxHeight: stackHeight)
			.frame(width: stackWidth)
		}
		.frame(alignment: .center)
	}
	
}

struct Setting_Previews: PreviewProvider {
	static var previews: some View {
		Setting()
			.environmentObject(TimerViewModel())
			.environmentObject(AppStateViewModel())
	}
}
