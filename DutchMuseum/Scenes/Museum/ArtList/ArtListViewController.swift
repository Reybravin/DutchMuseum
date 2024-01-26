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
        
        addCollectionView()
        bind(to: viewModel)
        
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        navigationItem.titleView = searchController.searchBar

        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search for Items"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.didEnterSearchQuery("Rembrandt van Rijn")
    }
    
    // MARK: - Private methods
    
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
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchString = searchController.searchBar.text
        
//        filtered = items.filter({ (item) -> Bool in
//            let countryText: NSString = item as NSString
//            
//            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//        })
//        
//        collectionView.reloadData()
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true
//        collectionView.reloadData()
//    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false
//        collectionView.reloadData()
//    }
    
//    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
//        if !searchActive {
//            searchActive = true
//            collectionView.reloadData()
//        }
//        
//        searchController.searchBar.resignFirstResponder()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(onSearchTextChange), object: searchBar)
        perform(#selector(onSearchTextChange), with: searchBar, afterDelay: 0.5)
    }
    
    @objc private func onSearchTextChange(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        viewModel?.didEnterSearchQuery(query)
        print(query)
    }
}

// MARK: - ArtListCollectionViewDelegate

extension ArtListViewController: ArtListCollectionViewDelegate {
    func didSelectItem(at indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath)
    }
}
