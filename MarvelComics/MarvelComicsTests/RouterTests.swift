//
//  RouterTests.swift
//  MarvelComicsTests
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import XCTest
@testable import MarvelComics

class RouterTests: XCTestCase {

    private var router: MCRouter!

    override func setUp() {
        super.setUp()
        router = MCRouter()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFirstState() {
        XCTAssertEqual(router.currentState, MCAppState.splashScreen)
    }

    func testSecondState() {
        router.goToNextScreen()
        XCTAssertEqual(router.currentState, MCAppState.characters)
    }

    func testChangeState() {
        router.goToState(.splashScreen)
        XCTAssertEqual(router.currentState, MCAppState.splashScreen)
    }
}
