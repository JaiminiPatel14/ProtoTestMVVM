//
//  Validator.swift
//  ProtoTestMVVM
//
//  Created by Jaimini Shah on 28/05/25.
//

struct Validator {
    static func isUsernameValid(_ username: String?) -> ValidationError {
        guard let username = username , username != "" else {
            return ValidationError.emptyUsername
        }
        return ValidationError.success
    }
    
    static func isPasswordValid(_ password: String?) -> ValidationError {
        guard let password = password , password != "" else {
            return ValidationError.emptyPassword
        }
        guard password.count >= 6 else {
            return ValidationError.lengthPassword
        }
        return ValidationError.success
    }
}
