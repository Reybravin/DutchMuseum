//
//  IMuseumService.swift
//  
//
//  Created by Serhii Sachuk on 18.09.2023.
//

import Foundation

public protocol IMuseumService {
    func fetchMakerArt(maker: String, page: Int, numberOfResultsPerPage: Int) async throws -> ArtObjectList

    func fetchArt(searchQuery: String, page: Int, numberOfResultsPerPage: Int) async throws -> ArtObjectList
}
