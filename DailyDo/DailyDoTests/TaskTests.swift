//
//  TaskTests.swift
//  DailyDoTests
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import XCTest
@testable import DailyDo

class TaskTests: XCTestCase {

    var sut: Task!
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testInitializerShouldInitWithDefaultValue() {
        sut = Task(title: "Test 1", priority: "p1", uuid: UUID().uuidString)
        XCTAssertEqual(sut.isComplete, false)
    }

}
