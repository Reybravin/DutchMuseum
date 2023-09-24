//
//  ViewController.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 18.09.2023.
//

import UIKit

final class ArtListViewController: UIViewController, IAlert {
    
    // MARK: - Private properties
    
    private var collectionView: ArtListCollectionView?
    
    //MARK: - Public propertis
    
    weak var coordinator: RootCoordinator?
    var viewModel: IArtListViewModel?
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCollectionView()
        bind(to: viewModel)
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
 
// MARK: - ArtListCollectionViewDelegate

extension ArtListViewController: ArtListCollectionViewDelegate {
    func didSelectItem(at indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath)
    }
}
