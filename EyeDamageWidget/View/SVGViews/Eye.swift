//
//  Eye.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2022-12-02.
//

import SwiftUI

struct Eye: View {
	let duration: Int
	
	let pathBounds = UIBezierPath.calculateBounds(paths: [.eye, .eyeball, .vessel1, .vessel2, .vessel3, .vessel4, .vessel5, .vessel6, .vessel7, .vessel8, .vessel9, .vessel10])
	var body: some View {
		ZStack {
			Group {
				ShapeView(bezier: .eye, pathBounds: pathBounds)
					.fill(Color(.black))
				ShapeView(bezier: .eyeball, pathBounds: pathBounds)
					.fill(Color(.black))
			}
			
			Group {
				ShapeView(bezier: .vessel1, pathBounds: pathBounds)
					.fill(duration>=180 ? Color(.systemRed): Color(.clear))
				ShapeView(bezier: .vessel9, pathBounds: pathBounds)
					.fill(duration>=360 ? Color(.systemRed): Color(.clear))
				ShapeView(bezier: .vessel5, pathBounds: pathBounds)
					.fill(duration>=540 ? Color(.systemRed): Color(.clear))
				ShapeView(bezier: .vessel7, pathBounds: pathBounds)
					.fill(duration>=720 ? Color(.systemRed): Color(.clear))
				ShapeView(bezier: .vessel3, pathBounds: pathBounds)
					.fill(duration>=900 ? Color(.systemRed): Color(.clear))
				ShapeView(bezier: .vessel6, pathBounds: pathBounds)
					.fill(duration>=1080 ? Color(.systemRed): Color(.clear))
				ShapeView(bezier: .vessel4, pathBounds: pathBounds)
					.fill(duration>=1260 ? Color(.systemRed): Color(.clear))
				ShapeView(bezier: .vessel10, pathBounds: pathBounds)
					.fill(duration>=1440 ? Color(.systemRed): Color(.clear))
				ShapeView(bezier: .vessel8, pathBounds: pathBounds)
					.fill(duration>=1620 ? Color(.systemRed): Color(.clear))
				ShapeView(bezier: .vessel2, pathBounds: pathBounds)
					.fill(duration>=1800 ? Color(.systemRed): Color(.clear))
			}
			
		}.frame(width: 200, height: 200)
	}
	
}
