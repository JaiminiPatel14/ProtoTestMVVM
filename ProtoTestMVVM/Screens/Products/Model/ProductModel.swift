//
//  ProductModel.swift
//  MVVM-withClosure
//
//  Created by Jaimini Shah on 19/05/25.
//

import Foundation

// MARK: - Product Model
struct ProductModel: Codable{
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

// MARK: - Rating Model
struct Rating: Codable{
    let rate: Double
    let count: Int
}
