//
//  PersistanceService.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import Foundation

class PersistanceService {
    static let shared = PersistanceService()
    
    let appDelegate = AppDelegate.getAppDelegate()
    let context = AppDelegate.getAppDelegate().persistentContainer.viewContext
    
    func fetchTasks(completed: Bool = false) -> [Task]? {
        
        let request = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "priority", ascending: true)
        let predicate = NSPredicate(format: "isComplete == %@", NSNumber(value: completed))
        print(completed)
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        do {
            return try context.fetch(request)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
        return nil
    }
    
    
}
