//
//  MockProductViewModelDelegate.swift
//  ProtoTestMVVMTests
//
//  Created by Jaimini Shah on 29/05/25.
//

import Foundation
import XCTest
@testable import ProtoTestMVVM

class MockProductViewModelDelegate: ProductViewModelDelegate {
    var isLoading = false
    var productsLoaded = false
    var networkError: NetworkServiceError?
    var productsExpectation: XCTestExpectation?
    
    func didStartLoading() {
        isLoading = true
    }
    
    func didStopLoading() {
        isLoading = false
    }
    
    func didLoadProducts() {
        productsLoaded = true
        productsExpectation?.fulfill()
    }
    
    func didFailWithError(_ error: NetworkServiceError) {
        networkError = error
        productsExpectation?.fulfill()
    }
} 