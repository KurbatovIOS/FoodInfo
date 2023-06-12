//
//  ProfileViewController.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 19.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Категории"
        navigationController?.navigationBar.prefersLargeTitles = true
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        setConstraints()
        
        sections[0].append("Шоколад")
        sections[1].append("Орех")
    }
    
    private let profileModel = ProfileViewModel()
    private var sections: [[String]] = Array(repeating: [], count: 3)
    
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
    
    private func setupHeader(for section: Int) -> UIView {
//        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 40, height: 70))
//        backgroundView.backgroundColor = .systemBackground
//        backgroundView.layer.cornerRadius = 10
//        backgroundView.clipsToBounds = true
        
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
        
        //backgroundView.addSubview(headerView)
        headerView.addSubview(clearButton)
        headerView.addSubview(addButton)
        headerView.addSubview(label)
        
        switch section {
        case 0:
            label.text = "Любимые"
            headerView.backgroundColor = .systemGreen//.withAlphaComponent(0.8)
        case 1:
            label.text = "Запрещенные"
            headerView.backgroundColor = .systemRed//.withAlphaComponent(0.8)
        case 2:
            label.text = "Нежелательные"
            headerView.backgroundColor = .systemOrange//.withAlphaComponent(0.8)
        default:
             break
        }
        return headerView
        //return backgroundView
    }
    
    
    @objc private func addToSectionDidTap(sender: UIButton) {
        profileModel.addProductToSection("123", &sections[sender.tag])
        categoriesTableView.reloadData()
    }
    
    @objc private func clearButtonDidTap(sender: UIButton) {
        sections[sender.tag].removeAll()
        categoriesTableView.reloadData()
    }
}

//MARK: - Extension
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
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
}
