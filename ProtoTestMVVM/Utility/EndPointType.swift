//
//  EndPointItem.swift
//  ProtoTestMVVM
//
//  Created by Jaimini Shah on 21/05/25.
//

import Foundation

// MARK: - Environment
enum Environment {
    case production
    case development
    
    // MARK: - Properties
    var baseURL: String {
        switch self {
        case .production:
            return "https://fakestoreapi.com/"
        case .development:
            return "https://fakestoreapi.com/"
        }
    }
}

// MARK: - HTTP Method
enum httpMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - EndPoint Type Protocol
protocol EndPointType {
    var path: String { get }
    var method: httpMethod { get }
    var parameters: [String: Any]? { get }
    var url: URL? { get }
    var baseURL: String { get }
    var headers: [String: String]? { get }
}

// MARK: - EndPoint Item
enum EndPointItem: EndPointType {
    case login(userName: String, password: String)
    case products
    
    // MARK: - EndPointType Implementation
    var path: String {
        switch self {
        case .products:
            return "products"
        case .login:
            return "auth/login"
        }
    }
    
    var method: httpMethod {
        switch self {
        case .products:
            return .get
        case .login:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .products:
            return nil
        case .login(let userName, let password):
            return [
                "username": userName,
                "password": password
            ]
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var baseURL: String {
        return Environment.development.baseURL
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
