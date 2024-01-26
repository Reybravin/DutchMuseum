//
//  MuseumArtsProvider.swift
//  
//
//  Created by Serhii Sachuk on 22.09.2023.
//

import Foundation

enum MuseumArtsEndpoint {
    case artByMaker(maker: String, page: Int, numberOfResultsPerPage: Int)
    case artByQuery(query: String, page: Int, numberOfResultsPerPage: Int)
}

internal struct MuseumArtsProvider: ApiEndpoint {
    
    private let apiKey: String
    private let language: String
    private let endpoint: MuseumArtsEndpoint
    
    init(endpoint: MuseumArtsEndpoint, api: String, language: String) {
        self.endpoint = endpoint
        self.apiKey = api
        self.language = language
    }

    var baseURLString: String {
        "https://www.rijksmuseum.nl"
    }
    
    var apiPath: String {
        "api"
    }
    
    var languagePath: String {
        language
    }
    
    var path: String {
        switch endpoint {
        case .artByMaker, .artByQuery:
            return "collection"
        }
    }
    
    var queryForCall: [URLQueryItem]? {
        switch endpoint {
        case .artByMaker(let maker, let page, let numberOfResultsPerPage):
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "key", value: apiKey))
            queryItems.append(URLQueryItem(name: "involvedMaker", value: maker))
            queryItems.append(URLQueryItem(name: "p", value: String(page)))
            queryItems.append(URLQueryItem(name: "ps", value: String(numberOfResultsPerPage)))
            return queryItems
        case .artByQuery(let query, let page, let numberOfResultsPerPage):
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "key", value: apiKey))
            queryItems.append(URLQueryItem(name: "q", value: query))
            queryItems.append(URLQueryItem(name: "p", value: String(page)))
            queryItems.append(URLQueryItem(name: "ps", value: String(numberOfResultsPerPage)))
            return queryItems
        }
    }
    
    var method: ApiHTTPMethod {
        .GET
    }
}
