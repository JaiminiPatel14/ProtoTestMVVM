//
//  MockNetworkService.swift
//  ProtoTestMVVMTests
//
//  Created by Jaimini Shah on 29/05/25.
//

import Foundation
@testable import ProtoTestMVVM

class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed = true
    var mockToken: String?
    var mockError: NetworkServiceError?
    var mockProducts: [ProductModel]?
    
    func request<T>(model: T.Type, endPoint: EndPointType) async throws -> T where T : Decodable, T : Encodable {
        if !shouldSucceed {
            throw mockError ?? .serverError(500)
        }
        
        // Handle login response
        if let urlString = endPoint.url?.absoluteString, urlString.contains("login") {
            if let loginModel = LoginModel(token: mockToken) as? T {
                return loginModel
            }
            throw NetworkServiceError.decodingFailed("Invalid login model type")
        }
        
        // Handle products response
        if let urlString = endPoint.url?.absoluteString, urlString.contains("products") {
            if let products = mockProducts as? T {
                return products
            }
            throw NetworkServiceError.decodingFailed("Invalid products model type")
        }
        
        throw NetworkServiceError.invalidResponse
    }
} 
