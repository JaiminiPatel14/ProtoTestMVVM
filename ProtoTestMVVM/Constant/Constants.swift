//
//  Constants.swift
//  ProtoTestMVVM
//
//  Created by Jaimini Shah on 21/05/25.
//

import UIKit

// MARK: - Constants
enum Constants {
    // MARK: - Cell Identifiers
    enum CellIndetifiers {
        static let productCellIdentifier = "ProductTVC"
    }
    
    // MARK: - Storyboard
    enum Storyboard {
        static let mainStoryboardName = UIStoryboard(name: "Main", bundle: nil)
    }
    
    // MARK: - View Controller
    enum ViewController {
        static let productViewControllerIdentifier = "ProductVC"
        static let loginViewControllerIdentifier = "LoginVC"
    }
    
    // MARK: - Error Messages
    enum ErrorMessage {
        static let invalidCredentials = "Invalid Credentials"
        static let genericError = "Something went wrong"
        static let emptyEmailOrPassword = "Email or Password cannot be empty"
    }
}
