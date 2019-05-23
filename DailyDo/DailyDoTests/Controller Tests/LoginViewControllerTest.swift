//
//  LoginViewControllerTest.swift
//  DailyDoTests
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import XCTest
@testable import DailyDo

class LoginViewControllerTest: XCTestCase {
    
    var sut: LoginViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = (storyboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testViewControllerShouldInstantiateFromUdentifier() {
        XCTAssertTrue(sut != nil)
    }

    
    func testSignInButtonShouldBeDisabled() {
        XCTAssertFalse(sut.loginButton.isEnabled)
    }
}
