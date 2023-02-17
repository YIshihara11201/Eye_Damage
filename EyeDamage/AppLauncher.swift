//
//  AppLauncher.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2023-01-29.
//

import SwiftUI

@main
struct AppLauncher {
	static func main() throws {
		if NSClassFromString("XCTestCase") == nil {
			EyeDamageApp.main()
		} else {
			TestApp.main()
		}
	}
}

class TestAppDelegate: NSObject, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		return true
	}
}

struct TestApp: App {
	
	var body: some Scene {
		WindowGroup { Text("Running Unit Tests") }
	}
}
