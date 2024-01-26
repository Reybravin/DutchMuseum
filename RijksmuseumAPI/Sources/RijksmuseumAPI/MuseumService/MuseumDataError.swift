//
//  MuseumDataError.swift
//  
//
//  Created by Serhii Sachuk on 21.09.2023.
//

import Foundation

public protocol AppError {
    var title: String { get }
    var message: String { get }
}

public enum MuseumDataError: Error {
    case invalidURL
}

extension MuseumDataError: AppError {
    public var title: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
    public var message: String {
        switch self {
        case .invalidURL:
            return "It is not you, it is our bad. We will fix this issue shortly."
        }
    }
}
