//
//  APISevice.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 23.09.2023.
//

import Foundation
import RijksmuseumAPI

public protocol API {
    var api: IAPIService { get }
}

extension API {
    public var api: IAPIService { APIService.shared }
}

public protocol IAPIService {
    var museum: IMuseumService { get }
}

private class APIService: IAPIService {
    
    fileprivate static let shared = APIService()
    
    private init() {}
    
    lazy var museum: IMuseumService = {
        let apiKey = Configuration.shared.apiKey
        let language = Configuration.shared.language
        return MuseumService(apiKey: apiKey, language: language)
    }()
}
