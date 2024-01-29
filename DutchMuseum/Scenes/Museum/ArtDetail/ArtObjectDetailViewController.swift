//
//  ArtObjectDetailViewController.swift
//  DutchMuseum
//
//  Created by Serhii Sachuk on 19.09.2023.
//

import UIKit
import Kingfisher

final class ArtObjectDetailViewController: UIViewController {
    
    // MARK: Private properties

    private var imageView: UIImageView?
    private var titleLabel: UILabel?
    private var subTitleLabel: UILabel?
    private var stackView: UIStackView?
    private let defaultViewInset: CGFloat = 20.0
    
    // MARK: Public properties
    
    var viewModel: ArtObjectViewModel?
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupViews()
    }
    
    // MARK: - Private methods

    private func setupViews() {
        guard let model = viewModel?.model else { return }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.label
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        let subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.textColor = UIColor.systemGray
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .left
        
        self.imageView = imageView
        self.titleLabel = titleLabel
        self.subTitleLabel = subTitleLabel
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subTitleLabel, UIView()])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            subTitleLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
    
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: defaultViewInset),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -defaultViewInset),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultViewInset),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -defaultViewInset)
        ])
        
        self.stackView = stackView
         
        if let url = model.webImage?.url {
            self.imageView?.kf.setImage(with: URL(string: url))
        }
        titleLabel.text = model.title
        subTitleLabel.text = model.longTitle
    }
    
}
