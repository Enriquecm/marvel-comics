//
//  ParserTests.swift
//  MarvelComicsTests
//
//  Created by Enrique Melgarejo on 05/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import XCTest
@testable import MarvelComics

class ParserTests: XCTestCase {

    private var dataImageMock: Data!

    override func setUp() {
        super.setUp()
        let image = MCModelImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/4c0038c02e75a", imageExtension: "jpg")
        let encoder = JSONEncoder()
        dataImageMock = try! encoder.encode(image)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParserMethods() {

        let imageParser = MCParser<MCModelImage>()
        XCTAssertNotNil(imageParser, "The parser should not be nil.")

        let image = try? imageParser.parse(from: dataImageMock, with: imageParser.dateDecodingStrategy())
        XCTAssertNotNil(image, "The image should not be nil.")
        XCTAssertEqual(image?.path, "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/4c0038c02e75a", "The path should be the same.")
        XCTAssertEqual(image?.imageExtension, "jpg", "The extension should be the same.")
    }
}
