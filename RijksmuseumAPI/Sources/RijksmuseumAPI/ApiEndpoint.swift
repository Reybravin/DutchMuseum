//
//  ApiEndpoint.swift
//  
//
//  Created by Serhii Sachuk on 22.09.2023.
//

import Foundation

protocol ApiEndpoint {
    var baseURLString: String { get }
    var apiPath: String { get }
    var languagePath: String { get }
    var path: String { get }
    var queryForCall: [URLQueryItem]? { get }
    var method: ApiHTTPMethod { get }
}

extension ApiEndpoint {
    
    var url: URL? {
        makeRequest.url
    }
    
    private var makeRequest: URLRequest {
        var urlComponents = URLComponents(string: baseURLString)
        var longPath = "/"
        longPath.append(apiPath)
        longPath.append("/")
        longPath.append(languagePath)
        longPath.append("/")
        longPath.append(path)
        urlComponents?.path = longPath
                
        if let queryForCalls = queryForCall {
            urlComponents?.queryItems = [URLQueryItem]()
            for queryForCall in queryForCalls {
                urlComponents?.queryItems?.append(URLQueryItem(name: queryForCall.name, value: queryForCall.value))
            }
        }
        
        guard let url = urlComponents?.url else { return URLRequest(url: URL(string: baseURLString)!) }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        return request
    }
    
}
