//
//  FirebaseService.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 12.06.2023.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

protocol FirebaseServiceProtocol {
    func getProduct(_ docName: String, from collectionName: String, complition: @escaping (Product?) -> Void)
    func getProducts(from collectionName: String, complition: @escaping ([Product]?) -> Void)
    func getProductImage(_ pictureName: String, complition: @escaping (Data?) -> Void)
    func sendAddProductRequest(code: String, title: String, ingredients: String)
}

class FirebaseService: FirebaseServiceProtocol {
    
    static let shared: FirebaseServiceProtocol = FirebaseService()
    
    private init(){}
    
    private func configureDB() -> Firestore {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        return Firestore.firestore()
    }
    
    func getProducts(from collectionName: String, complition: @escaping ([Product]?) -> Void) {
        let db = configureDB()
        db.collection(collectionName).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                complition(nil)
                return
            }
            
            var products: [Product] = []
            
            for document in snapshot.documents {
                if let title = document.get("title") as? String,
                   let ingredients = document.get("ingredients") as? String,
                   let imageName = document.get("imageName") as? String {
                    products.append(Product(title: title, ingredients: ingredients, imageName: imageName))
                }
            }
            complition(products)
        }
    }
    
    func getProduct(_ docName: String, from collectionName: String, complition: @escaping (Product?) -> Void) {
        let db = configureDB()
        db.collection(collectionName).document(docName).getDocument { document, error in
            guard error == nil else {
                complition(nil)
                return
            }
            
            guard
                let title = document?.get("title") as? String,
                let ingredients = document?.get("ingredients") as? String,
                let imageName = document?.get("imageName") as? String
            else {
                complition(nil)
                return
            }
            
            let product = Product(title: title, ingredients: ingredients, imageName: imageName)
            complition(product)
        }
    }
    
    func getProductImage(_ pictureName: String, complition: @escaping (Data?) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathReference = reference.child("productImages")
        
        let fileReference = pathReference.child(pictureName)
        fileReference.getData(maxSize: 1024*1024) { data, error in
            guard let data = data, error == nil else {
                complition(nil)
                return
            }
            complition(data)
        }
    }
    
    func sendAddProductRequest(code: String, title: String, ingredients: String) {
        let db = configureDB()
        let product = ["title" : title, "ingredients" : ingredients, "imageName" : ""]
        db.collection(Identifiers.productsToReviewCollection).document(code).setData(product) { error in
            guard error == nil else {
                return
            }
        }
    }
}
