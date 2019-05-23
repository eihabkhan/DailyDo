//
//  Task.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import Foundation


class Task {
    dynamic var title: String
    dynamic var isComplete: Bool
    dynamic var priority: String
    dynamic var uuid: String
    
    init(title: String, isComplete: Bool = false, priority: String, uuid: String) {
        self.title = title
        self.isComplete = isComplete
        self.priority = priority
        self.uuid = uuid
    }
    
    
}
