//
//  DutchMuseumTests.swift
//  DutchMuseumTests
//
//  Created by Serhii Sachuk on 18.09.2023.
//

import XCTest
import RijksmuseumAPI
@testable import DutchMuseum

final class DutchMuseumTests: XCTestCase {

    func testConfiguration() {
        let configuration = Configuration()
        
        XCTAssertNoThrow(configuration.apiKey)
        XCTAssertEqual(configuration.language, "nl")
    }
}

