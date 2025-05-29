//
//  LoginVC.swift
//  MVVM-withClosure
//
//  Created by Jaimini Shah on 19/05/25.
//

import UIKit

// MARK: - Login View Controller
class LoginVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblUsername: CustomTextField!
    @IBOutlet weak var lblPass: CustomTextField!
    
    // MARK: - Properties
    private let viewModel: LoginViewModel
    weak var coordinator: AuthCoordinator?

    // MARK: - Initialization
    required init?(coder: NSCoder) {
        self.viewModel = LoginViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        lblUsername.placeholder = "Username"
        lblPass.placeholder = "Password"
        lblPass.isSecureTextEntry = true
        
        // Add keyboard handling
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @IBAction func btnLoginAction(_ sender: Any) {
        guard let username = lblUsername.text, !username.isEmpty,
              let password = lblPass.text, !password.isEmpty else {
            self.showError(.custom(Constants.ErrorMessage.invalidCredentials))
            return
        }
        viewModel.login(username: username, password: password)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Login View Model Delegate
extension LoginVC: LoginViewModelDelegate {
    func didStartLoading() {
        self.showLoading(message: "Logging in...")
    }
    
    func didStopLoading() {
        self.hideLoading()
    }
    
    func didLoginSuccessfully() {
        self.hideLoading()
        self.coordinator?.showProductList()
    }
    
    func didFailWithError(_ error: NetworkServiceError) {
        self.hideLoading()
        self.showError(error)
    }
    
    func didFailWithValidationError(_ message: String) {
        self.hideLoading()
        self.showError(.custom(message))
    }
}
