//
//  EyeDamageApp.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-18.
//

import SwiftUI
import LocalAuthentication

struct EyeDamageApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@Environment(\.scenePhase) private var scenePhase
	@State private var showingAlert = false
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.preferredColorScheme(.light)
				.alert(isPresented: $showingAlert) {
					Alert(
						title: Text("Passcord Requirement"),
						message: Text("You must set passcord(finger print) to enable this application."),
						dismissButton: .default(Text("Set passcord"), action: {
							exit(0)
						}))
				}
				.environmentObject(appDelegate.timerVM)
				.environmentObject(appDelegate.appStateVM)
		}.onChange(of: scenePhase, perform: { phase in
			switch scenePhase {
			case .active:
				if !devicePasscodeIsSet() {
					showingAlert = true
#if DEBUG
					showingAlert = false
#endif
				}
			default: break
			}
		})
	}
	
	private func devicePasscodeIsSet() -> Bool {
		return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
	}
	
}
