//
//  ProfileViewController.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 19.02.2023.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: UI
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.categoriesCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var presenter: CategoriesPresenterProtocol
    private var products: Set<String> = []
    private var sections: [[String]] = Array(repeating: [], count: 3)
    
    init(presenter: CategoriesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Категории"
        navigationController?.navigationBar.prefersLargeTitles = true
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        setConstraints()
        loadCategories()
    }
    
    // MARK: - Constraints
    private func setConstraints() {
        view.addSubview(categoriesTableView)
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            categoriesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func loadCategories() {
        sections = presenter.loadCategories()
        DispatchQueue.global().async {
            for section in self.sections {
                for product in section {
                    self.products.insert(product)
                }
            }
        }
        categoriesTableView.reloadData()
    }
    
    private func setupHeader(for section: Int) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 40, height: 70))
        headerView.layer.cornerRadius = 10
        headerView.clipsToBounds = true
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: headerView.frame.width / 2, height: 70))
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title2)
        
        let addButton = UIButton(frame: CGRect(x: view.frame.width - 70, y: headerView.frame.height / 2 - 10, width: 20, height: 20))
        addButton.tag = section
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addToSectionDidTap), for: .touchUpInside)
        addButton.tintColor = .white
        
        let clearButton = UIButton(frame: CGRect(x: view.frame.width - 40, y: headerView.frame.height / 2 - 10, width: 20, height: 20))
        clearButton.tag = section
        clearButton.setImage(UIImage(systemName: "trash"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
        clearButton.tintColor = .white
        
        headerView.addSubview(clearButton)
        headerView.addSubview(addButton)
        headerView.addSubview(label)
        
        switch section {
        case 0:
            label.text = "Любимые"
            headerView.backgroundColor = .systemGreen
        case 1:
            label.text = "Запрещенные"
            headerView.backgroundColor = .systemRed
        case 2:
            label.text = "Нежелательные"
            headerView.backgroundColor = .systemOrange
        default:
             break
        }
        return headerView
    }
    
    @objc private func addToSectionDidTap(sender: UIButton) {
        let alert = UIAlertController(title: "Добавить продукт", message: "Введите название продукта", preferredStyle: .alert)
        alert.addTextField()
        let addAction = UIAlertAction(title: "Добавить", style: .cancel, handler: { _ in
            guard let productName = alert.textFields?.first?.text, !productName.isEmpty else {
                return
            }
            self.addProduct(productName, sender.tag)
        })
        let cancel = UIAlertAction(title: "Отменить", style: .default)
        alert.addAction(addAction)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func addProduct(_ productName: String, _ sectionTag: Int) {
        if !products.contains(productName) {
            let category = sections[sectionTag]
            let sectionName = presenter.getCategoryName(sectionTag)
            let newSection = presenter.addProductToSection(productName, category, sectionName)
            sections[sectionTag] = newSection
            products.insert(productName)
            categoriesTableView.reloadData()
        }
    }
    
    @objc private func clearButtonDidTap(sender: UIButton) {
        sections[sender.tag].removeAll()
        presenter.clearCategory(sender.tag)
        categoriesTableView.reloadData()
    }
}

//MARK: - Extension
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: Identifiers.categoriesCell, for: indexPath)
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        setupHeader(for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, complition in
            self.presenter.deleteProduct(self.sections[indexPath.section][indexPath.row])
            self.sections[indexPath.section].remove(at: indexPath.row)
            self.categoriesTableView.reloadData()
            complition(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

