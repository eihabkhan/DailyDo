//
//  TaskEditorViewControllerTest.swift
//  DailyDoTests
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import XCTest
@testable import DailyDo

class TaskEditorViewControllerTest: XCTestCase {
    
    var sut: TaskEditorViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = (storyboard.instantiateViewController(withIdentifier: "TaskEditor") as! TaskEditorViewController)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testViewControllerShouldInstantiateFromUdentifier() {
        XCTAssertTrue(sut != nil)
    }

    
    func testAddTaskButtonShouldBeDisabled() {
        sut.titleField.text = "Test"
        XCTAssertFalse(sut.addTaskButton.isEnabled)
    }
    
    func testOutletCollectionIncludeOnlyFourButtons() {
        XCTAssertEqual(sut.priorityButtons.count, 4)
    }
    
    func testOnlyOnePriorityButtonIsFocused() {
        var focusedButtonCount = 0
        for button in sut.priorityButtons {
            if button.alpha > 0.3 {
                focusedButtonCount += 1
            }
        }
        XCTAssertEqual(focusedButtonCount, 1)
    }
    
}
