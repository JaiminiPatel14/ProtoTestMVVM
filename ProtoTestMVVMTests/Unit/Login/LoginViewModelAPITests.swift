//
//  LoginViewModelAPITests.swift
//  ProtoTestMVVMTests
//
//  Created by Jaimini Shah on 29/05/25.
//

import XCTest
@testable import ProtoTestMVVM

final class LoginViewModelAPITests: XCTestCase {
    var loginViewModel: LoginViewModel!
    var mockDelegate: MockLoginViewModelDelegate!
    var mockNetworkService: MockNetworkService!
    
    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
        mockDelegate = MockLoginViewModelDelegate()
        loginViewModel = LoginViewModel(networkService: mockNetworkService)
        loginViewModel.delegate = mockDelegate
    }
    
    override func tearDownWithError() throws {
        loginViewModel = nil
        mockDelegate = nil
        mockNetworkService = nil
    }
    
    func testLogin_Success() {
        // Given
        mockNetworkService.shouldSucceed = true
        mockNetworkService.mockToken = "test-token"
        let expectation = expectation(description: "Login should succeed")
        mockDelegate.loginExpectation = expectation
        
        // When
        loginViewModel.login(username: "test@example.com", password: "123456")
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockDelegate.loginSuccess)
        XCTAssertFalse(mockDelegate.isLoading)
        XCTAssertNil(mockDelegate.networkError)
    }
    
    func testLogin_NetworkError() {
        // Given
        mockNetworkService.shouldSucceed = false
        mockNetworkService.mockError = .unauthorized
        let expectation = expectation(description: "Login should fail with network error")
        mockDelegate.loginExpectation = expectation
        
        // When
        loginViewModel.login(username: "test@example.com", password: "123456")
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(mockDelegate.loginSuccess)
        XCTAssertFalse(mockDelegate.isLoading)
        XCTAssertEqual(mockDelegate.networkError, .unauthorized)
    }
    
    func testLogin_InvalidCredentials() {
        // Given
        mockNetworkService.shouldSucceed = false
        mockNetworkService.mockError = .custom("Invalid credentials")
        let expectation = expectation(description: "Login should fail with invalid credentials")
        mockDelegate.loginExpectation = expectation
        
        // When
        loginViewModel.login(username: "test@example.com", password: "123456")
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(mockDelegate.loginSuccess)
        XCTAssertFalse(mockDelegate.isLoading)
        XCTAssertEqual(mockDelegate.networkError?.userFacingMessage, "Invalid credentials")
    }
    
    func testLogin_LoadingState() {
        // Given
        mockNetworkService.shouldSucceed = true
        mockNetworkService.mockToken = "test-token"
        let expectation = expectation(description: "Login should complete loading state")
        mockDelegate.loginExpectation = expectation
        
        // When
        loginViewModel.login(username: "test@example.com", password: "123456")
        
        // Then - Check loading state immediately
        XCTAssertTrue(mockDelegate.isLoading)
        
        // Wait for completion
        wait(for: [expectation], timeout: 2.0)
        
        // Then - Check final state
        XCTAssertFalse(mockDelegate.isLoading)
        XCTAssertTrue(mockDelegate.loginSuccess)
    }
} 
