//
//  ViewModel.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 18.09.2023.
//

import Foundation
import RijksmuseumAPI

enum MuseumRoute {
    case details(ArtObject)
}

protocol IArtListViewModelInput {
    func didEnterSearchQuery(_ query: String)
    func didSelectItem(at indexPath: IndexPath)
    func didReachBottom()
}

protocol IArtListViewModelOutput {
    var error: Observable<(title: String?, message: String?)?> { get }
    var collectionViewData: Observable<(models: [[ArtObject]], headers: [String])?> { get }
    var route: Observable<MuseumRoute?> { get }
}

protocol IArtListViewModel: IArtListViewModelInput, IArtListViewModelOutput {}


final class ArtListViewModel: IArtListViewModel, API {
       
    // MARK: - Public properties
    
    let collectionViewData = Observable<(models: [[ArtObject]], headers: [String])?>(nil)
    let error = Observable<(title: String?, message: String?)?>(nil)
    let route = Observable<MuseumRoute?>(nil)

    // MARK: - Private properties
    
    private var fetchedData: ArtObjectList?
    private var searchQuery: String?
    private var page: Int = 0
    private let numberOfResultsPerPage = 10
    private var numberOfAvailablePages: Int {
        (fetchedData?.count ?? 0) / numberOfResultsPerPage
    }

    private var isLoadingMore = false
    
    // MARK: - Public methods
    
    func didEnterSearchQuery(_ query: String) {
        guard searchQuery != query else { return }
        
        searchQuery = query
        resetData()
        
        Task {
            let data = await loadData(searchQuery: query, page: self.page)
            fetchedData = data
            collectionViewData.send((models: [data?.artObjects ?? [] ], headers: [query]))
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let models = fetchedData?.artObjects,
              models.indices.contains(indexPath.row) else { return }
        
        let model = models[indexPath.row]
        route.send(.details(model))
    }
    
    func didReachBottom() {
        guard (fetchedData?.count ?? 0) / numberOfResultsPerPage - 1 > page,
                !isLoadingMore,
                let searchQuery else { return }
        Task {
            isLoadingMore = true
            page += 1
            let data = await loadData(searchQuery: searchQuery, page: page)
            if let newObjects = data?.artObjects {
                fetchedData?.artObjects?.append(contentsOf: newObjects)
                collectionViewData.send((models: [fetchedData?.artObjects ?? [] ], headers: [searchQuery]))
            }
            isLoadingMore = false
        }
    }
    
    // MARK: Private methods

    private func loadData(searchQuery: String, page: Int) async -> ArtObjectList? {
        do {
            let data = try await api.museum.fetchMakerArt(maker: searchQuery, page: page, numberOfResultsPerPage: numberOfResultsPerPage)
//            let data = try await api.museum.fetchArt(searchQuery: searchQuery, page: page, numberOfResultsPerPage: numberOfResultsPerPage)
            return data
        } catch {
            if let err = error as? AppError {
                self.error.send((title: err.title, message: err.message))
            } else {
                self.error.send((title: "Error", message: error.localizedDescription))
            }
            return nil
        }
    }
    
    private func resetData() {
        fetchedData = nil
        page = 0
        isLoadingMore = false
    }

}
