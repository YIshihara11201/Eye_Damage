//
//  LockScreen.swift
//  EyeDamageWidgetExtension
//
//  Created by Yusuke Ishihara on 2022-11-19.
//

import SwiftUI
import ActivityKit
import WidgetKit

@available(iOSApplicationExtension 16.1, *)
struct LockScreenView: View {
	
	var context: ActivityViewContext<EyeDamageWidgetAttributes>
	
	var body: some View {
		VStack(alignment: .center) {
			HStack() {
				Spacer()
				Eye(duration: context.state.phoneActiveTime)
				Spacer()
				Text("\(context.state.phoneActiveTime/60) min \(context.state.phoneActiveTime%60) sec")
					.font(.custom("Manrope", size: 22))
					.foregroundColor(.black)
				Spacer()
			}
		}
	}
	
}
