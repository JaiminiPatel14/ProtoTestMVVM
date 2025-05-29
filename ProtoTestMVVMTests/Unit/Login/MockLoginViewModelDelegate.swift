//
//  MockLoginViewModelDelegate.swift
//  ProtoTestMVVMTests
//
//  Created by Jaimini Shah on 29/05/25.
//

import Foundation
import XCTest
@testable import ProtoTestMVVM

class MockLoginViewModelDelegate: LoginViewModelDelegate {
    var validationError: String?
    var isLoading = false
    var loginSuccess = false
    var networkError: NetworkServiceError?
    var loginExpectation: XCTestExpectation?
    
    func didStartLoading() {
        isLoading = true
    }
    
    func didStopLoading() {
        isLoading = false
    }
    
    func didLoginSuccessfully() {
        loginSuccess = true
        loginExpectation?.fulfill()
    }
    
    func didFailWithError(_ error: NetworkServiceError) {
        networkError = error
        loginExpectation?.fulfill()
    }
    
    func didFailWithValidationError(_ message: String) {
        validationError = message
    }
} 
