//
//  MCServiceTests.swift
//  MarvelComicsTests
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import XCTest
@testable import MarvelComics

class MCServiceTests: XCTestCase {

    private var deadPool: DeadPoolProtocolMock!
    private var errorHandling: MCServiceErrorProtocol!

    override func setUp() {
        super.setUp()
        errorHandling = MCServiceErrorHandling()
        let service = MCServiceMock(serviceError: errorHandling)
        deadPool = DeadPoolMock(service: service)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCharacters() {
        deadPool.marvelCharacters(filterParameters: MCFilterParameters(offset: 0, limit: 20), completion: nil)
        XCTAssertTrue(deadPool.didRequestCharacters, "The request method should be called.")
    }

    func testCharacterWithId() {
        deadPool.marvelCharacter(withId: 10001, completion: nil)
        XCTAssertTrue(deadPool.didRequestCharacter, "The request method should be called.")
    }

    func testErrorHandling() {
        let errorCode: Int = 404
        let message: String = "We couldn\'t find that character"
        let jsonString = "{\"code\":\(errorCode),\"status\":\"\(message)\"}"

        let data = jsonString.data(using: .utf8)
        let error = errorHandling.errorFrom(data)
        XCTAssertEqual(error?.statusCode, errorCode, "The Status Code should be the same of the json object")
        XCTAssertEqual(error?.message, message, "The Message should be the same of the json object")
    }

    func testErrorHandlingForInvalidJson() {
        let jsonString = "[{\"code\":404,\"status\":\"We couldn\'t find that character\"}]"

        let data = jsonString.data(using: .utf8)
        let error = errorHandling.errorFrom(data)
        XCTAssertNil(error, "The Error object should be nil if the json is in incorrect format")
    }

    func testStaticErrors() {
        let unknownError = MCNetworkError.unknownError()
        XCTAssertEqual(unknownError.statusCode, -1, "The Error Status Code should be -1")
        XCTAssertEqual(unknownError.message, "An unknown error happened.", "The Error message should be an unknown")

        let parseError = MCNetworkError.parseError()
        XCTAssertEqual(parseError.statusCode, -1001, "The Error Status Code should be -1001")
        XCTAssertEqual(parseError.message, "Internal server error.")

        let noConnection = MCNetworkError.noConnection()
        XCTAssertEqual(noConnection.statusCode, -1001, "The Error Status Code should be -1")
        XCTAssertEqual(noConnection.message, "No internet connection.")

        let timedOut = MCNetworkError.timedOut()
        XCTAssertEqual(timedOut.statusCode, -1, "The Error Status Code should be -1")
        XCTAssertEqual(timedOut.message, "Service timeout.")

        let unexpectedError = MCNetworkError.unexpectedError(message: "Error message")
        XCTAssertEqual(unexpectedError.statusCode, -1, "The Error Status Code should be -1")
        XCTAssertEqual(unexpectedError.message, "Error message")
    }

    func testResponseModel() {
        let response = MCResponse(statusCode: 404, data: nil, error: MCNetworkError.unknownError(), request: nil, response: nil)
        XCTAssertEqual(response.statusCode, 404)
        XCTAssertNil(response.data, "The Data should be nil")
        XCTAssertEqual(response.error?.statusCode, MCNetworkError.unknownError().statusCode)
        XCTAssertNil(response.request, "The Data should be nil")
        XCTAssertNil(response.response, "The Data should be nil")
    }

    func testMarvelAPICharacters() {
        let deadPool = DeadPool(service: MCService(serviceError: errorHandling))
        let filter = MCFilterParameters(offset: 0, limit: 20, nameStartsWith: nil)

        let readyExpectation = expectation(description: "ready")
        deadPool.marvelCharacters(filterParameters: filter) { (data, error) in
            XCTAssertNil(error, "The Error should be nil")
            XCTAssertNotNil(data, "The Error should not be nil")

            guard let data = data else { return }
            let parser = MCParser<MCModelCharacterDataWrapper>()
            let result = try? parser.parse(from: data, with: parser.dateDecodingStrategy())
            let characters = result?.data?.results ?? []
            XCTAssertEqual(characters.count, 20, "The results is not equal to limit")
            readyExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: {error in XCTAssertNil(error, "Error in expectation")})
    }

    func testMarvelAPICharacter() {
        let deadPool = DeadPool(service: MCService(serviceError: errorHandling))

        let readyExpectation = expectation(description: "ready")
        deadPool.marvelCharacter(withId: 1017100) { (data, error) in
            XCTAssertNil(error, "The Error should be nil")
            XCTAssertNotNil(data, "The Error should not be nil")

            let parser = MCParser<MCModelCharacterDataWrapper>()
            let result = try? parser.parse(from: data!, with: parser.dateDecodingStrategy())
            let characters = result?.data?.results ?? []
            XCTAssertEqual(characters.count, 1, "The results should be unique")

            let character = characters.first
            XCTAssertEqual(character?.id, 1017100, "The id should be 1017100")
            XCTAssertEqual(character?.name, "A-Bomb (HAS)", "The results should be 'A-Bomb (HAS)'")
            readyExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: {error in XCTAssertNil(error, "Error in expectation")})
    }
}

private class MCServiceMock: MCServiceProtocol {
    private(set) var didRequest = false

    required init(serviceError: MCServiceErrorProtocol) { }

    func requestHttp(url: MCURLConvertible?, method: MCHTTPMethod, parameters: MCParameters?, encoding: MCParameterEncoding, headers: MCHTTPHeaders?, completion: MCRequestResponse) {
        didRequest = true
    }
}

protocol DeadPoolProtocolMock: DeadPoolProtocol {

    var didRequestCharacters: Bool { get set }
    var didRequestCharacter: Bool { get set }
}

private class DeadPoolMock: DeadPoolProtocolMock {

    var didRequestCharacters: Bool
    var didRequestCharacter: Bool
    private var service: MCServiceProtocol

    required init(service: MCServiceProtocol) {
        didRequestCharacters = false
        didRequestCharacter = false
        self.service = service
    }

    func marvelCharacters(filterParameters: MCFilterParameters, completion: ((Data?, MCNetworkError?) -> Void)?) {
        didRequestCharacters = true
        service.requestHttp(url: nil, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, completion: nil)
    }

    func marvelCharacter(withId characterId: Int, completion: ((Data?, MCNetworkError?) -> Void)?) {
        didRequestCharacter = true
        service.requestHttp(url: nil, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, completion: nil)
    }
}
