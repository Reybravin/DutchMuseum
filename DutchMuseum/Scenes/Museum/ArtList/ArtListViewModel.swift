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
    func didSelectPage(_ page: Int)
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
    private var page: Int = 1
    
    // MARK: - Public methods
    
    func didEnterSearchQuery(_ query: String) {
        guard self.searchQuery != query else { return }
        
        self.searchQuery = query
        getNewData(searchQuery: query, page: self.page)
    }

    func didSelectPage(_ page: Int) {
        guard let searchQuery,
              self.page != page else { return }
        
        getNewData(searchQuery: searchQuery, page: page)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let models = fetchedData?.artObjects,
              models.indices.contains(indexPath.row) else { return }
        
        let model = models[indexPath.row]
        route.send(.details(model))
    }

    private func getNewData(searchQuery: String, page: Int) {
        Task {
            do {
                let data = try await api.museum.fetchMakerArt(searchQuery: searchQuery, page: page)
                fetchedData = data
                self.collectionViewData.send((models: [data.artObjects ?? [] ], headers: [searchQuery]))
            } catch {
                if let err = error as? AppError {
                    self.error.send((title: err.title, message: err.message))
                } else {
                    self.error.send((title: "Error", message: error.localizedDescription))
                }
            }
        }
    }

}
