//
//  Configuration.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 20.09.2023.
//

import Foundation

final public class Configuration {
    
    // MARK: - Private properties
    
    private var plist: [String: Any]?
    
    // MARK: - Public Properties
    
    public var apiKey: String {
        guard let json = plist?["RijksMuseum"] as? [String: Any],
              let apiKey = json["apiKey"] as? String else {
            fatalError("❗️Can't read 'RijksMuseum' in Configuration.plist")
        }
        return apiKey
    }
    
    public var language: String {
        "nl"
    }
    
    // MARK: - Initialization
    
    static let shared = Configuration()

    init() {
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        guard let path = Bundle.main.path(forResource: "Configuration",
                                          ofType: "plist") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data,
                                                                   options: .mutableContainers,
                                                                   format: nil) as? [String: Any] {
            
            self.plist = plist
        }
    }
}
