//
//  ApiEndpointTests.swift
//  
//
//  Created by Serhii Sachuk on 24.09.2023.
//

import XCTest
@testable import RijksmuseumAPI

final class ApiEndpointTests: XCTestCase {
    
    var sut: MockApiEndpoint!
    
    override func setUpWithError() throws {
        sut = MockApiEndpoint()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testMakingURL() throws {
        let testUrl = try XCTUnwrap(sut.url)
        let compareAgaints = try XCTUnwrap(URL(string: "https://www.rijksmuseum.nl/api/nl/collection"))
        XCTAssertEqual(testUrl, compareAgaints)
    }
    
}
