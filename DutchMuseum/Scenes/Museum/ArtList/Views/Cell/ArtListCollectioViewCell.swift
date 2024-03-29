//
//  CollectionViewCell.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 19.09.2023.
//

import UIKit
import Kingfisher
import RijksmuseumAPI

final class ArtListCollectioViewCell: UICollectionViewCell {
    
    // MARK: - Private properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func addViews() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
    }

    private func loadImage(urlString: String) {
        guard let  url = URL(string: urlString) else { return }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: self.frame.height,
                                                                height: self.frame.height))
        
        imageView.kf.indicatorType = .activity
        
        imageView.kf.setImage(with: url,
                              options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                //.cacheSerializer(FormatIndicatedCacheSerializer.png),
                                .cacheOriginalImage
                              ])
    }
    
    // MARK: - Public methods
    public func config(model: ArtObject) {
        nameLabel.text = model.title
        if let urlString = model.webImage?.url {
            loadImage(urlString: urlString)
        }
    }
}
