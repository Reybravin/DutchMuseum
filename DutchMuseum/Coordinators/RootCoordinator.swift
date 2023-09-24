//
//  RootCoordinator.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 23.09.2023.
//

import UIKit
import RijksmuseumAPI

final class RootCoordinator: ICoordinator {
    
    var childCoordinators = [ICoordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ArtListViewController()
        vc.viewModel = ArtListViewModel()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func artObjectDetails(model: ArtObject) {
        let vc = ArtObjectDetailViewController()
        vc.viewModel = ArtObjectViewModel(model: model)
        navigationController.pushViewController(vc, animated: true)
    }
}
