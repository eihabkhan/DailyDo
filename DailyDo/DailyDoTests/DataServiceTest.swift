//
//  DataServiceTest.swift
//  DailyDoTests
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import XCTest
@testable import DailyDo
import Firebase

class DataServiceTest: XCTestCase {

    var sut: DataService!
    
    override func setUp() {
        super.setUp()
        sut = DataService()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testShouldFetchTasks() {
        let uid = "BshOa06EPMcjMQcUXU6hMr63wsC2"
        sut.REF_TASKS.child(uid).queryOrdered(byChild: "priority").observeSingleEvent(of: .value) { (snapshot) in
            var tasks = [Task]()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    let data = snap.value as! [String: Any]
                    let isComplete = Bool(number: data["isComplete"] as! Int)
                    let uuid = snap.key
                    let title = data["title"] as! String
                    let priority = data["priority"] as! String
                    let task = Task(title: title, isComplete: isComplete, priority: priority, uuid: uuid)
                    tasks.append(task)
                }
                XCTAssertFalse(tasks.isEmpty)
            }
        }
    }
    
    func testShouldSignInUser() {
        Auth.auth().signIn(withEmail: "ee@e.com", password: "123456") { (result, error) in
            if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                XCTFail("Error(\(errorCode)): \(error.localizedDescription)")
            } else {
                XCTAssertTrue(result?.user != nil)
            }
        }
    }
    
}
