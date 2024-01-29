//
//  ViewController.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 18.09.2023.
//

import UIKit

final class ArtListViewController: UIViewController, IAlert {
    
    // MARK: - Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var collectionView: ArtListCollectionView?

    //MARK: - Public propertis
    
    weak var coordinator: RootCoordinator?
    var viewModel: IArtListViewModel?
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBar()
        addCollectionView()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.isActive = true
        searchController.searchBar.text = "Rembrandt van Rijn"
    }
    
    // MARK: - Private methods
    
    private func addSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter artist's name..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    private func addCollectionView() {
        let collectionView = ArtListCollectionView(frame: view.frame)
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
    private func bind(to viewModel: IArtListViewModel?) {
        guard let viewModel else { return }
        
        viewModel.error.bind { [weak self] error in
            self?.alertService.show(title: error?.title, message: error?.message)
        }
        
        viewModel.collectionViewData.bind { [weak collectionView] result in
            guard let collectionView, let result else { return }
            collectionView.setupData(models: result.models, headers: result.headers)
        }
        
        viewModel.route.bind { [weak self] in self?.handleRoute($0) }
    }
    
    private func handleRoute(_ route: MuseumRoute?) {
        guard let route else { return }
        switch route {
        case .details(let model):
            coordinator?.artObjectDetails(model: model)
        }
    }
}

extension ArtListViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        onSearchTextChange(searchController.searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(onSearchTextChange), object: searchBar)
        perform(#selector(onSearchTextChange), with: searchBar, afterDelay: 0.5)
    }
    
    @objc private func onSearchTextChange(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            return
        }
        viewModel?.didEnterSearchQuery(query)
    }
}

// MARK: - ArtListCollectionViewDelegate

extension ArtListViewController: ArtListCollectionViewDelegate {
    func didSelectItem(at indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath)
    }
    
    func didReachBottom() {
        viewModel?.didReachBottom()
    }
}
