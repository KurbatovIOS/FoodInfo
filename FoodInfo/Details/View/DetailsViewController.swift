//
//  DetailsViewController.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 25.05.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
        
    private lazy var productConsistencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Состав:"
        label.textColor = .systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let presenter: DetailsPresenterProtocol
    private let productToDisplay: Product
    private let imageData: Data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setConstraints()
        configureView()
    }
    
    init(productToDisplay: Product, imageData: Data, presenter: DetailsPresenterProtocol) {
        self.productToDisplay = productToDisplay
        self.imageData = imageData
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        productTitleLabel.text = productToDisplay.title
        productDescriptionLabel.text = productToDisplay.ingredients
        productImageView.image = UIImage(data: imageData)
        let attributedText = presenter.highlightIngredients(productToDisplay.ingredients)
        productDescriptionLabel.attributedText = attributedText
    }
    
    private func setConstraints() {
        view.addSubview(productImageView)
        view.addSubview(productTitleLabel)
        view.addSubview(separatorView)
        view.addSubview(scrollView)
        view.addSubview(productConsistencyLabel)
        scrollView.addSubview(productDescriptionLabel)
        let scrollContentGuide = scrollView.contentLayoutGuide
        let scrollFrameGuide = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            productTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            productTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            productTitleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 15),
            
            separatorView.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 5),
            separatorView.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: productTitleLabel.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            productConsistencyLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5),
            productConsistencyLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
            productConsistencyLabel.trailingAnchor.constraint(equalTo: productTitleLabel.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: productConsistencyLabel.bottomAnchor, constant: 5),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: productTitleLabel.trailingAnchor),
            
            productDescriptionLabel.topAnchor.constraint(equalTo: scrollContentGuide.topAnchor),
            productDescriptionLabel.bottomAnchor.constraint(equalTo: scrollContentGuide.bottomAnchor),
            productDescriptionLabel.leadingAnchor.constraint(equalTo: scrollContentGuide.leadingAnchor),
            productDescriptionLabel.trailingAnchor.constraint(equalTo: scrollContentGuide.trailingAnchor),
            
            productDescriptionLabel.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor),
            productDescriptionLabel.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor),
        ])
    }
}
