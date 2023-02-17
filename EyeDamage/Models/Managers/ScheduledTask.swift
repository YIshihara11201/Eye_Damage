//
//  ScheduledTask.swift
//  EyeDamage
//
//  Created by Yusuke Ishihara on 2023-01-20.
//

import Foundation
import BackgroundTasks

struct ScheduledTask {
	static func scheduleTerminateLiveActivity(endDate: Date) {
		let request = BGAppRefreshTaskRequest(identifier: "terminateLiveActivities")
		request.earliestBeginDate = endDate
		try? BGTaskScheduler.shared.submit(request)
	}
}
