//
//  ArtListCollectionView.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 22.09.2023.
//

import UIKit
import RijksmuseumAPI

final class ArtListCollectionView: UIView {
    
    // MARK: - Private properties
    
    private let cell = ArtListCollectioViewCell.self
    private var collectionView: UICollectionView?
    private var headers: [String]?
    private var models: [[ArtObject]]?
    
    // MARK: - Public properties
    
    weak var delegate: ArtListCollectionViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20,
                                           left: 10,
                                           bottom: 10,
                                           right: 10)
        layout.itemSize = CGSize(width: frame.width - 20.0,
                                 height: 100)
        
        
        let collectionView = UICollectionView(frame: self.frame,
                                              collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Cell
        collectionView.register(cell,
                                forCellWithReuseIdentifier: String(describing: cell))
        collectionView.backgroundColor = UIColor.white
        
        // Header
        let headerView = ArtListHeaderView.self
        collectionView.register(headerView,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: headerView))
        
        addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - Public methods
    
    func setupData(models: [[ArtObject]]?, headers: [String]?) {
        self.models = models
        self.headers = headers
        
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ArtListCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let models,
              models.indices.contains(section) else {
            return 0
        }
        
        return models[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: String(describing: self.cell),
                                 for: indexPath) as? ArtListCollectioViewCell else {
            return UICollectionViewCell()
        }
        
        if let model = models?[indexPath.section][indexPath.row] {
            cell.config(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headers,
              headers.indices.contains(indexPath.section) else {
            return UICollectionReusableView()
        }
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind,
                                              withReuseIdentifier: String(describing: ArtListHeaderView.self),
                                              for: indexPath) as? ArtListHeaderView else { return UICollectionReusableView()
           }
           
           headerView.config(text: headers[indexPath.section])
           return headerView

       default:
           assert(false, "Unexpected element kind")
       }
    }
 
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
        
extension ArtListCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        delegate?.didSelectItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard models != nil else { return CGSize.zero }
        
        return CGSize(width: collectionView.frame.width,
                      height: 40.0)
    }
}
