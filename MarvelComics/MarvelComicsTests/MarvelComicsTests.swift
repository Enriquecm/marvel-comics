//
//  MarvelComicsTests.swift
//  MarvelComicsTests
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import XCTest
@testable import MarvelComics

class MarvelComicsTests: XCTestCase {

    var apiKeys: MCApiKeys!
    override func setUp() {
        super.setUp()

        apiKeys = MCApiKeys()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testApiKeys() {
        let publicKey = apiKeys.publicKey
        let privateKey = apiKeys.privateKey

        XCTAssertEqual(publicKey, apiKeys.value(forAPIKeyName: "MARVEL_PUBLIC_KEY"), "The Public Key should be the same of the .plist object")
        XCTAssertEqual(privateKey, apiKeys.value(forAPIKeyName: "MARVEL_PRIVATE_KEY"), "The Public Key should be the same of the .plist object")
    }
    
}
