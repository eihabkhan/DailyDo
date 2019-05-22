//
//  DataService.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let shared = DataService()
    
    private(set) var REF_BASE = DB_BASE
    private(set) var REF_TASKS = DB_BASE.child("tasks")
    private(set) var REF_USERS = DB_BASE.child("users")
    
    func createUser(uid: String, userData: [String: Any]) {

        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func create(task: Task) {
        guard let uid = AuthService.shared.currentUserUID else { return }
        REF_TASKS.child(uid).child(task.uuid).setValue([
            "title": task.title,
            "isComplete": task.isComplete,
            "priority": task.priority
            ])
    }
    
    func delete(task: Task) {
        guard let uid = AuthService.shared.currentUserUID else { return }
        REF_TASKS.child(uid).child(task.uuid).removeValue()
    }
    
    func readTasks(completion: @escaping ([Task]) -> ()) {
        var tasks = [Task]()
        guard let uid = AuthService.shared.currentUserUID else { return }
        REF_TASKS.child(uid).queryOrdered(byChild: "priority").observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    let data = snap.value as! [String: Any]
                    let task = Task(context: AppDelegate.getAppDelegate().persistentContainer.viewContext)
                    task.isComplete = Bool(number: data["isComplete"] as! Int)
                    task.uuid = snap.key
                    task.title = data["title"] as! String
                    task.priority = data["priority"] as! String
                    tasks.append(task)
                }

                completion(tasks)

            }
        }
    }
    
    
}
