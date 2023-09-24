//
//  Coordinator.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 23.09.2023.
//

import UIKit

protocol ICoordinator {
    var childCoordinators: [ICoordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
