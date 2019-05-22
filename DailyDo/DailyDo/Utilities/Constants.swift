//
//  Constants.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import Foundation
import Firebase


enum TaskPriority: String {
    case p1
    case p2
    case p3
    case p4
}


let DB_BASE = Database.database().reference()
