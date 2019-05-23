//
//  SignupViewControllerTest.swift
//  DailyDoTests
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import XCTest
@testable import DailyDo

class SignupViewControllerTest: XCTestCase {

    var sut: SignupViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = (storyboard.instantiateViewController(withIdentifier: "Signup") as! SignupViewController)
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
