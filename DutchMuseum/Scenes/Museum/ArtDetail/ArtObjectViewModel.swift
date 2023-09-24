//
//  ArtObjectViewModel.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 20.09.2023.
//

import Foundation
import RijksmuseumAPI

final class ArtObjectViewModel: API {
    
    // MARK: Public properties
    
    public let model: ArtObject
    
    // MARK: - Initialization
    
    init(model: ArtObject) {
        self.model = model
    }
    
}
