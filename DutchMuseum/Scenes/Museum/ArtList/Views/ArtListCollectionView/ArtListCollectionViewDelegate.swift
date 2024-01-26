//
//  ArtListCollectionViewDelegate.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 22.09.2023.
//

import Foundation

protocol ArtListCollectionViewDelegate: AnyObject {
    func didSelectItem(at indexPath: IndexPath)
    func didReachBottom()
}
