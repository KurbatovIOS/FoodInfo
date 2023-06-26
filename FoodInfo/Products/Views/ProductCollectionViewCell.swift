//
//  ProductCollectionViewCell.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 11.05.2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        productImageView.image = nil
        productTitleLabel.text = nil
    }
    
    func configure(with product: Product) {
        productTitleLabel.text = product.title
    }
    
    func setImage(_ image: Data?) {
        if let imageData = image {
            productImageView.image = UIImage(data: imageData)
        }
    }
    
    private func setConstraints() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productTitleLabel)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            
            productTitleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 5),
            productTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            productTitleLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 5),
            productTitleLabel.heightAnchor.constraint(lessThanOrEqualTo: productImageView.heightAnchor, constant: -10)
        ])
    }
}
