//
//  ProductViewModelTests.swift
//  ProtoTestMVVMTests
//
//  Created by Jaimini Shah on 29/05/25.
//

import XCTest
@testable import ProtoTestMVVM

final class ProductViewModelTests: XCTestCase {
    var productViewModel: ProductViewModel!
    var mockDelegate: MockProductViewModelDelegate!
    var mockNetworkService: MockNetworkService!
    
    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
        mockDelegate = MockProductViewModelDelegate()
        productViewModel = ProductViewModel(networkService: mockNetworkService)
        productViewModel.delegate = mockDelegate
    }
    
    override func tearDownWithError() throws {
        productViewModel = nil
        mockDelegate = nil
        mockNetworkService = nil
    }
    
    // MARK: - Data Fetching Tests
    
    func testFetchProducts_Success() {
        // Given
        let mockProducts = [
            ProductModel(id: 1, title: "Test Product", price: 99.99, description: "Test Description", category: "Test Category", image: "test.jpg", rating: Rating(rate: 4.5, count: 100))
        ]
        mockNetworkService.shouldSucceed = true
        mockNetworkService.mockProducts = mockProducts
        let expectation = expectation(description: "Products should load successfully")
        mockDelegate.productsExpectation = expectation
        
        // When
        productViewModel.fetchProducts()
        
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertTrue(mockDelegate.productsLoaded)
        XCTAssertFalse(mockDelegate.isLoading)
        XCTAssertNil(mockDelegate.networkError)
        XCTAssertEqual(productViewModel.products.count, 1)
        XCTAssertEqual(productViewModel.products.first?.title, "Test Product")
    }
    
    func testFetchProducts_NetworkError() {
        // Given
        mockNetworkService.shouldSucceed = false
        mockNetworkService.mockError = .serverError(500)
        let expectation = expectation(description: "Products should fail with network error")
        mockDelegate.productsExpectation = expectation
        
        // When
        productViewModel.fetchProducts()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(mockDelegate.productsLoaded)
        XCTAssertFalse(mockDelegate.isLoading)
        XCTAssertEqual(mockDelegate.networkError, .serverError(500))
        XCTAssertTrue(productViewModel.products.isEmpty)
    }
    
    func testFetchProducts_LoadingState() {
        // Given
        mockNetworkService.shouldSucceed = true
        mockNetworkService.mockProducts = []
        let expectation = expectation(description: "Products should complete loading state")
        mockDelegate.productsExpectation = expectation
        
        // When
        productViewModel.fetchProducts()
        
        // Then - Check loading state immediately
        XCTAssertTrue(mockDelegate.isLoading)
        
        // Wait for completion
        wait(for: [expectation], timeout: 2.0)
        
        // Then - Check final state
        XCTAssertFalse(mockDelegate.isLoading)
        XCTAssertTrue(mockDelegate.productsLoaded)
    }
    
    // MARK: - Product Access Tests
    
    func testGetProduct_ValidIndex() {
        // Given
        let mockProducts = [
            ProductModel(id: 1, title: "Product 1", price: 99.99, description: "Description 1", category: "Category 1", image: "image1.jpg", rating: Rating(rate: 4.5, count: 100)),
            ProductModel(id: 2, title: "Product 2", price: 149.99, description: "Description 2", category: "Category 2", image: "image2.jpg", rating: Rating(rate: 4.0, count: 50))
        ]
        mockNetworkService.shouldSucceed = true
        mockNetworkService.mockProducts = mockProducts
        let expectation = expectation(description: "Products should load for valid index test")
        mockDelegate.productsExpectation = expectation
        
        // When
        productViewModel.fetchProducts()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertNotNil(productViewModel.getProduct(at: 0))
        XCTAssertEqual(productViewModel.getProduct(at: 0)?.title, "Product 1")
        XCTAssertNotNil(productViewModel.getProduct(at: 1))
        XCTAssertEqual(productViewModel.getProduct(at: 1)?.title, "Product 2")
    }
    
    func testGetProduct_InvalidIndex() {
        // Given
        let mockProducts = [
            ProductModel(id: 1, title: "Product 1", price: 99.99, description: "Description 1", category: "Category 1", image: "image1.jpg", rating: Rating(rate: 4.5, count: 100))
        ]
        mockNetworkService.shouldSucceed = true
        mockNetworkService.mockProducts = mockProducts
        let expectation = expectation(description: "Products should load for invalid index test")
        mockDelegate.productsExpectation = expectation
        
        // When
        productViewModel.fetchProducts()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertNil(productViewModel.getProduct(at: -1))
        XCTAssertNil(productViewModel.getProduct(at: 1))
    }
} 
