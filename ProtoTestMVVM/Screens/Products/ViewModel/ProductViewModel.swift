//
//  ProductViewModel.swift
//  ProtoTestMVVM
//
//  Created by Jaimini Shah on 19/05/25.
//

import Foundation

protocol ProductViewModelDelegate: AnyObject {
    func didStartLoading()
    func didStopLoading()
    func didLoadProducts()
    func didFailWithError(_ error: NetworkServiceError)
}

final class ProductViewModel {
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    weak var delegate: ProductViewModelDelegate?
    
    private var productList: [ProductModel] = []
    // Public Read-Only
    var products: [ProductModel] {
        productList
    }
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    func fetchProducts() {
        delegate?.didStartLoading()
        Task {
            do {
                let products = try await networkService.request(model: [ProductModel].self, endPoint: EndPointItem.products)
                self.productList = products
                await MainActor.run {
                    self.delegate?.didLoadProducts()
                    self.delegate?.didStopLoading()
                }
            } catch {
                await MainActor.run {
                    self.delegate?.didStopLoading()
                    if let networkError = error as? NetworkServiceError {
                        self.delegate?.didFailWithError(networkError)
                    } else {
                        self.delegate?.didFailWithError(NetworkServiceError.custom(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    func getProduct(at index: Int) -> ProductModel? {
        guard index >= 0 && index < productList.count else { return nil }
        return productList[index]
    }
}

