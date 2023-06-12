//
//  CollectionViewController.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 01.04.2023.
//

import UIKit

class ProductsListViewController: UIViewController {
    
    private var dumbImages = [
        "maffin",
        "yogurt",
        "milk",
        "juice",
        "jam",
        "cake",
        "fish",
        "dumplings",
        "chocolate"
    ]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        setupSearchController()
        setupConstraints()
        generateDumbData()
    }
    
    private func generateDumbData() {
        products.append(Product(code: UUID().uuidString, title: "Маффин Три шоколада «Русская нива»", ingredients: "Сахар, масло растительное подсолнечное, продукт яичный, вода питьевая, мука пшеничная хлебопекарная высшего сорта, начинка кремовая шоколадная нетермостабильная (сироп глюкозно-фруктозный, вода питьевая, сахар, шоколад (какао тертое, сахар, масло какао, молочный жир, эмульгатор - лецитин подсолнечника, ароматизатор), масло растительное кокосовое, сыворотка сухая молочная подсырная, стабилизатор Е1442, какао-порошок, консервант - сорбат калия, регулятор кислотности - лимонная кислота, ароматизатор), глицерин, какао-порошок алкализованный, шоколад белый (сахар, сухое цельное молоко, масло какао, сухое обезжиренное молоко, эмульгатор - лецитин соевый, ароматизатор), глазурь шоколадная молочная (сахар, сухое цельное молоко, масло какао, какао тертое, сухая молочная сыворотка, сухое обезжиренное молоко, лецитин соевый, ароматизатор), дрожжи хлебопекарные сухие дезактивированные, соль, загуститель Е1422", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "Питьевой йогурт Epica с клубникой м маракуйей 2,5%", ingredients: "Обезжиренное молоко, наполнитель «Клубника-маракуйя» (сахар, клубника, вода, сок маракуйи, крахмал кукурузный, концентрированный сок черной моркови, концентрированный сок моркови, ароматизаторы натуральные, концентрированный лимонный сок), сливки, молочный белок, йогуртовая закваска", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "Молоко 3,4-4,5% «Домик в деревне» пастеризованное отборное", ingredients: "Молоко цельное.", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "Напиток сокосодержащий Вишнёвая черешня «Любимый»", ingredients: "Яблочный сок, вишневый сок, сок из черешни, сахар или сахар и глюкозно-фруктозный сироп, регулятор кислотности-лимонная кислота, ароматизатор натуральный, вода", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "Джем «Ратибор» клубничный", ingredients: "Сахар, клубника, фруктовое пюре, пектин, лимонная кислота", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "Пирожные Профитроли ванильные «Фили-Бейкер»", ingredients: "Яйца куриные, мука пшеничная высшего сорта, молоко сгущенное с сахаром (молоко, сахар, лактоза), маргарин (рафинированные дезодорированные растительные масла, вода, эмульгаторы: эфиры полиглицерина и жирных кислот, моно- и диглицериды жирных кислот, соль, сахар, консервант сорбат калия, регулятор кислотности лимонная кислота, ароматизатор, краситель бета-каротин, антиокислители: аскорбиновая кислота, альфа-токоферол), сливки молочные, сметана (сливки, закваска молочнокислых микроорганизмов), соль, ароматизатор ванилин, консервант сорбиновая кислота. Возможно наличие кунжута, арахиса и орехов (фундук, миндаль, грецкий орех)", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "Сельдь кусочки XXL крупные с луком «Матиас» в масле", ingredients: "Филе сельди, масло подсолнечное, лук, соль, укроп, регуляторы кислотности, винная, лимонная кислоты, уксусная кислота ледяная, усилитель вкуса и аромата глутамат натрия 1-замещенный, консерванты: бензоат натрия, сорбат калия, подсластитель сахарин", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "Пельмени Иркутские «Сибирская Коллекция»", ingredients: "Фарш - говядина, свинина, лук репчатый свежий, сливки питьевые, вода питьевая, соль, перец чёрный молотый, сахар. Тесто - мука пшеничная высший сорт, вода питьевая, меланж яичный, масло подсолнечное высший сорт, соль", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "Шоколад Milka молочный Карамель", ingredients: "1 - Шоколад молочный (сахар, масло какао, какао тёртое, молоко сухое цельное, сыворотка сухая молочная, молоко сухое обезжиренное, жир молочный, эмульгаторы (лецитин соевый, E 476), паста ореховая (фундук), ароматизатор), начинка (патока крахмальная карамельная, сахар, жир растительный, сыворотка сухая молочная, ароматизаторы, соль, эмульгатор (E 471), регуляторы кислотности (E 500i, кислота лимонная)). 2 - Шоколад молочный (сахар, масло какао, какао тёртое, молоко сухое цельное, сыворотка сухая молочная, молоко сухое обезжиренное, жир молочный, эмульгаторы (лецитин соевый, Е 476), паста ореховая (фундук), ароматизатор), начинка (сироп глюкозный, сахар, глюкозно-фруктозный сироп, жир растительный, сыворотка сухая молочная, ароматизаторы, соль, эмульгатор (Е 471). регулятор кислотности (E 500i)).", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "", ingredients: "", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "", ingredients: "", imageURL: nil))
        products.append(Product(code: UUID().uuidString, title: "", ingredients: "", imageURL: nil))
        
        filteredProducts = products
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
        var imageName = "logo"
        if dumbImages.count-1 >= indexPath.row {
            imageName = dumbImages[indexPath.row]
        }
        cell.configure(with: filteredProducts[indexPath.row], and: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var imageName = "logo"
        if dumbImages.count-1 >= indexPath.row {
            imageName = dumbImages[indexPath.row]
        }
        productsCollectionView.deselectItem(at: indexPath, animated: true)
        let detailsVC = DetailsViewController(productToDisplay: filteredProducts[indexPath.row], dumbImageName: imageName)
        present(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productsCollectionView.frame.size.width, height: view.frame.size.height / 12)
    }
}
