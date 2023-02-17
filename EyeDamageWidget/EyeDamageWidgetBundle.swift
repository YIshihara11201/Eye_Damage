//
//  EyeDamageWidgetBundle.swift
//  EyeDamageWidget
//
//  Created by Yusuke Ishihara on 2022-11-19.
//

import WidgetKit
import SwiftUI

@main
struct EyeDamageWidgetBundle: WidgetBundle {
	var body: some Widget {
		if #available(iOS 16.1, *) {
			EyeDamageWidgetLiveActivity()
		}
	}
}
