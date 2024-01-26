//
//  MuseumServiceTests.swift
//  
//
//  Created by Serhii Sachuk on 24.09.2023.
//

import XCTest
@testable import RijksmuseumAPI

final class MuseumServiceTests: XCTestCase {
    
    var sut: MuseumService!
    
    override func setUpWithError() throws {
        sut = MuseumService(apiKey: "", language: "nl")
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testFetchMakerArt() async throws {
        let result = try await sut.fetchMakerArt(maker: "Rembrandt van Rijn", page: 1, numberOfResultsPerPage: 10)
        XCTAssertNotNil(result.artObjects)
    }
    
}
