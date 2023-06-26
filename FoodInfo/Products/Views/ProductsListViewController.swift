//
//  CollectionViewController.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 01.04.2023.
//

import UIKit

class ProductsListViewController: UIViewController {
        
    private var imageData: [Int : Data] = [:]
    
    private lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.productCell)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var searchController = UISearchController()
    private lazy var filteredProducts: [Product] = []
    private lazy var products: [Product] = []
    private var presenter: ProductPresenterProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    init(presenter: ProductPresenterProtocol, coreDataService: CoreDataServiceProtocol) {
        self.presenter = presenter
        self.coreDataService = coreDataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        presenter.delegate = self
        setupSearchController()
        setupConstraints()
        presenter.getProducts()
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupConstraints() {
        view.addSubview(productsCollectionView)
        NSLayoutConstraint.activate([
            productsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            productsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            productsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            productsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ProductsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = []
        
        if searchText == "" {
            filteredProducts = products
        }
        else {
            for product in products {
                if product.title.lowercased().contains(searchText.lowercased()) {
                    filteredProducts.append(product)
                }
            }
        }
        self.productsCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredProducts = products
        self.productsCollectionView.reloadData()
    }
}

extension ProductsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.productCell, for: indexPath) as? ProductCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: filteredProducts[indexPath.row])
        if let image = imageData[indexPath.row] {
            cell.setImage(image)
        } else {
            presenter.loadImage(for: filteredProducts[indexPath.row]) { [weak self] imageData in
                guard let self else { return }
                self.imageData[indexPath.row] = imageData
                cell.setImage(imageData)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = imageData[indexPath.row] {
            let presenter = DetailsPresenter(coreDataService: coreDataService)
            let detailsVC = DetailsViewController(productToDisplay: filteredProducts[indexPath.row], imageData: image, presenter: presenter)
            present(detailsVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productsCollectionView.frame.size.width, height: view.frame.size.height / 12)
    }
}

extension ProductsListViewController: ProductPresenterDelegate {
    func productesRecieved(_ products: [Product]) {
        self.products = products
        self.filteredProducts = products
        self.productsCollectionView.reloadData()
    }
}
