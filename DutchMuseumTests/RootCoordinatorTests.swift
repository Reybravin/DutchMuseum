//
//  RootCoordinatorTests.swift
//  DutchMuseumTests
//
//  Created by Serhii Sachuk on 24.09.2023.
//

import XCTest
import RijksmuseumAPI
@testable import DutchMuseum

final class RootCoordinatorTests: XCTestCase {
    
    var sut: RootCoordinator!
    
    static func getFile(_ name: String, withExtension: String) -> Data? {
        guard let url = Bundle(for: Self.self)
                .url(forResource: name, withExtension: withExtension) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
  
    override func setUpWithError() throws {
        let navController = UINavigationController()
        sut = RootCoordinator(navigationController: navController)
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testStart() {
        sut.start()
        let condition = sut.navigationController.viewControllers.last is ArtListViewController
        XCTAssertNotNil(condition)
        XCTAssertTrue(condition)
    }
    
    func testArtObjectDetails() throws {
        let data = Self.getFile("collection", withExtension: "json")
        XCTAssertNotNil(data, "File not found")
        
        let decoded: ArtObjectList = try JSONDecoder().decode(ArtObjectList.self, from: data!)
        let model = decoded.artObjects?.first
        XCTAssertNotNil(model, "File not found")
        
        sut.artObjectDetails(model: model!)
        XCTAssertTrue(sut.navigationController.viewControllers.last is ArtObjectDetailViewController)
    }
}

