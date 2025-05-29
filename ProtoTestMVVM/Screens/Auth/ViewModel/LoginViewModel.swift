//
//  LoginViewModel.swift
//  ProtoTestMVVM
//
//  Created by Jaimini Shah on 19/05/25.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didStartLoading()
    func didStopLoading()
    func didLoginSuccessfully()
    func didFailWithError(_ error: NetworkServiceError)
    func didFailWithValidationError(_ message: String)
}

final class LoginViewModel {
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    weak var delegate: LoginViewModelDelegate?
    private var loginData: LoginModel?
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    func login(username: String, password: String) {
        guard validateLogin(username: username, password: password) else {
            return
        }
        
        delegate?.didStartLoading()
        Task {
            do {
                let loginAPI = try await networkService.request(model: LoginModel.self, endPoint: EndPointItem.login(userName: username, password: password))
                self.loginData = loginAPI
                await MainActor.run {
                    self.delegate?.didStopLoading()
                    self.delegate?.didLoginSuccessfully()
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
    func validateLogin(username: String, password: String) -> Bool {
        let usernameValidation = Validator.isUsernameValid(username)
        guard usernameValidation == .success else {
            delegate?.didFailWithValidationError(usernameValidation.rawValue)
            return false
        }
        let passwordValidation = Validator.isPasswordValid(password)
        guard passwordValidation == .success else {
            delegate?.didFailWithValidationError(passwordValidation.rawValue)
            return false
        }
        return true
    }
}


