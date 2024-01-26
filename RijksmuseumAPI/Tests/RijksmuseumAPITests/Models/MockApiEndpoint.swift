//
//  MockApiEndpoint.swift
//  
//
//  Created by Serhii Sachuk on 24.09.2023.
//

import XCTest
@testable import RijksmuseumAPI

internal class MockApiEndpoint: ApiEndpoint {
    
    var baseURLString: String {
        "https://www.rijksmuseum.nl"
    }
    
    var apiPath: String {
        "api"
    }
    
    var languagePath: String {
        "nl"
    }
    
    var path: String {
        "collection"
    }
    
    var queryForCall: [URLQueryItem]? {
        nil
    }
    
    var method: ApiHTTPMethod {
        .GET
    }
    
    
}
