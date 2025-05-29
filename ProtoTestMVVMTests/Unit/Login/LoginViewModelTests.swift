//
//  LoginViewModelTests.swift
//  ProtoTestMVVMTests
//
//  Created by Jaimini Shah on 29/05/25.
//

import XCTest
@testable import ProtoTestMVVM

final class LoginViewModelTests: XCTestCase {
    
    var loginViewModel: LoginViewModel!
    var mockDelegate: MockLoginViewModelDelegate!
    
    override func setUpWithError() throws {
        self.loginViewModel = LoginViewModel()
        self.mockDelegate = MockLoginViewModelDelegate()
        self.loginViewModel.delegate = mockDelegate
    }
    
    override func tearDownWithError() throws {
        self.loginViewModel = nil
        self.mockDelegate = nil
    }
    
    // MARK: - Username Validation Tests
    
    func testUsernameValidation_EmptyUsername() {
        // Given
        let username = ""
        let password = "123456"
        
        // When
        let isValid = loginViewModel.validateLogin(username: username, password: password)
        
        // Then
        XCTAssertFalse(isValid)
        XCTAssertEqual(mockDelegate.validationError, ValidationError.emptyUsername.rawValue)
    }
    
    func testUsernameValidation_NilUsername() {
        // Given
        let username: String? = nil
        let password = "123456"
        
        // When
        let isValid = loginViewModel.validateLogin(username: username ?? "", password: password)
        
        // Then
        XCTAssertFalse(isValid)
        XCTAssertEqual(mockDelegate.validationError, ValidationError.emptyUsername.rawValue)
    }
    
    func testUsernameValidation_ValidUsername() {
        // Given
        let username = "test@example.com"
        let password = "123456"
        
        // When
        let isValid = loginViewModel.validateLogin(username: username, password: password)
        
        // Then
        XCTAssertTrue(isValid)
        XCTAssertNil(mockDelegate.validationError)
    }
    
    // MARK: - Password Validation Tests
    
    func testPasswordValidation_EmptyPassword() {
        // Given
        let username = "test@example.com"
        let password = ""
        
        // When
        let isValid = loginViewModel.validateLogin(username: username, password: password)
        
        // Then
        XCTAssertFalse(isValid)
        XCTAssertEqual(mockDelegate.validationError, ValidationError.emptyPassword.rawValue)
    }
    
    func testPasswordValidation_NilPassword() {
        // Given
        let username = "test@example.com"
        let password: String? = nil
        
        // When
        let isValid = loginViewModel.validateLogin(username: username, password: password ?? "")
        
        // Then
        XCTAssertFalse(isValid)
        XCTAssertEqual(mockDelegate.validationError, ValidationError.emptyPassword.rawValue)
    }
    
    func testPasswordValidation_ShortPassword() {
        // Given
        let username = "test@example.com"
        let password = "12345" // Less than 6 characters
        
        // When
        let isValid = loginViewModel.validateLogin(username: username, password: password)
        
        // Then
        XCTAssertFalse(isValid)
        XCTAssertEqual(mockDelegate.validationError, ValidationError.lengthPassword.rawValue)
    }
    
    func testPasswordValidation_ValidPassword() {
        // Given
        let username = "test@example.com"
        let password = "123456" // Exactly 6 characters
        
        // When
        let isValid = loginViewModel.validateLogin(username: username, password: password)
        
        // Then
        XCTAssertTrue(isValid)
        XCTAssertNil(mockDelegate.validationError)
    }
    
    // MARK: - Combined Validation Tests
    
    func testLoginValidation_Success() {
        // Given
        let username = "test@example.com"
        let password = "123456"
        
        // When
        let isValid = loginViewModel.validateLogin(username: username, password: password)
        
        // Then
        XCTAssertTrue(isValid)
        XCTAssertNil(mockDelegate.validationError)
    }
    
    func testLoginValidation_BothInvalid() {
        // Given
        let username = ""
        let password = "12345"
        
        // When
        let isValid = loginViewModel.validateLogin(username: username, password: password)
        
        // Then
        XCTAssertFalse(isValid)
        XCTAssertEqual(mockDelegate.validationError, ValidationError.emptyUsername.rawValue)
    }
}
