//
//  ArtObjectList.swift
//  
//
//  Created by Serhii Sachuk on 20.09.2023.
//

import Foundation

public struct ArtObjectList: Decodable {
    public private (set) var count: Int?
    public var artObjects: [ArtObject]?
}
