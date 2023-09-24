//
//  Observable.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 22.09.2023.
//

import Foundation

final class Observable<T> {
    typealias Listener = (T) -> Void
    
    private var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
    func removeListner() {
         listener = nil
    }
    
    func send(_ value: T) {
        self.value = value
    }
}
