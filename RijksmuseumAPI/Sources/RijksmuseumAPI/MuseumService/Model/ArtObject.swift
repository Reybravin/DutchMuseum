//
//  ArtObject.swift
//  
//
//  Created by Serhii Sachuk on 20.09.2023.
//

import Foundation

public struct ArtObject: Decodable {
    
    public private(set) var id: String?
    public private(set) var title: String?
    public private(set) var longTitle: String?
    public private(set) var webImage: WebImage?
    
    public struct WebImage: Decodable {
        public private(set) var url: String?
    }
    
}

extension ArtObject: Equatable {
    public static func == (lhs: ArtObject, rhs: ArtObject) -> Bool {
        lhs.id == rhs.id
    }
}
