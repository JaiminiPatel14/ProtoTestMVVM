//
//  ValidationError.swift
//  ProtoTestMVVM
//
//  Created by Jaimini Shah on 28/05/25.
//

import Foundation

enum ValidationError: String {
    case emptyUsername = "Username cannot be empty"
    case emptyPassword = "Password cannot be empty"
    case lengthPassword = "Password should be more then 6 characters"
    case success = "Success"
    
}
