//
//  AddRequestViewController.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 27.05.2023.
//

import UIKit

class AddRequestViewController: UIViewController {
    
    private lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Код товара"
        return textField
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Название товара"
        return textField
    }()
    
    private lazy var ingredientsTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.text = "Состав"
        textView.textColor = UIColor.systemGray4
        textView.showsVerticalScrollIndicator = false
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 0.5
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sendButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        ingredientsTextView.delegate = self
        setConstraints()
    }
    
    private func setConstraints() {
        view.addSubview(codeTextField)
        view.addSubview(titleTextField)
        view.addSubview(ingredientsTextView)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            codeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            codeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            codeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            titleTextField.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            ingredientsTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            ingredientsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            ingredientsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            ingredientsTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            sendButton.topAnchor.constraint(equalTo: ingredientsTextView.bottomAnchor, constant: 10),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
        ])
    }
    
    @objc private func sendButtonDidTap() {
        ingredientsTextView.endEditing(true)
    }
}

extension AddRequestViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray4 {
             textView.text = nil
             textView.textColor = UIColor.black
         }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
              textView.text = "Состав"
              textView.textColor = UIColor.systemGray4
          }
    }
}
