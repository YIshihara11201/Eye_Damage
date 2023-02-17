//
//  File.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-11-29.
//

import SwiftUI

struct GrayButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.background(Color.gray)
			.foregroundColor(.black)
			.clipShape(Capsule())
	}
}

struct GrowingButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.background(Color(red: 1, green: 119/233, blue: 119/233))
			.foregroundColor(.white)
			.clipShape(Capsule())
			.scaleEffect(configuration.isPressed ? 1.4 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}
