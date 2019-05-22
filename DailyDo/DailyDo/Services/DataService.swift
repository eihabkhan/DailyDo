//
//  DataService.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import Foundation


class DataService {
    static let shared = DataService()
    
    private(set) var REF_BASE = DB_BASE
    private(set) var REF_TASKS = DB_BASE.child("tasks")
    private(set) var REF_USERS = DB_BASE.child("users")
    
    func createUser(uid: String, userData: [String: Any]) {
        print("Creating child: \(uid), and user info: \(userData)")
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
