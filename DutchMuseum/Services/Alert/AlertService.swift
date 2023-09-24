//
//  AlertService.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 21.09.2023.
//

import UIKit

// MARK: - IAlert

public protocol IAlert {
    var alertService: IAlertService { get }
}

public extension IAlert {
    var alertService: IAlertService { AlertService.shared }
}

// MARK: - IAlertService

public protocol IAlertService {
    func show(title: String?,
              message: String?)
}

// MARK: - AlertService

private class AlertService: IAlertService {
    
    // MARK: - Private properties
    
    fileprivate static let shared = AlertService()
    
    // MARK: - Private methods
    
    private init() {}
    
    // MARK: - Public methods
    
    func show(title: String? = nil,
              message: String? = nil) {
        
//        guard let controller = UIApplication.topViewController(), !(controller is UIAlertController) else { return }
        
        guard let controller = UIApplication.shared.topViewController(),
                !(controller is UIAlertController) else { return }
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "ok",
                                            style: .default)
            
            alertController.addAction(alertAction)
            
            controller.present(alertController,
                               animated: true) {
            }
        }
    }
}

// MARK: - Usage Example
//alertService.show(title: "Title", message: "Message")
