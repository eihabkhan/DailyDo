//
//  HistoryViewControllerTest.swift
//  DailyDoTests
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import XCTest
@testable import DailyDo

class HistoryViewControllerTest: XCTestCase {

    var sut: HistoryViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = (storyboard.instantiateViewController(withIdentifier: "History") as! HistoryViewController)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testViewControllerShouldInstantiateFromUdentifier() {
        XCTAssertTrue(sut != nil)
    }

}
