//
//  ErrorManager.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import Foundation
import Firebase

class ErrorManager {
    static let shared = ErrorManager()
    
    func handleSignUpError(forCode code: AuthErrorCode) -> String {
        var errorMessage: String
        switch code {
        case.emailAlreadyInUse:
            errorMessage = "Email Already in use"
        case .invalidEmail:
            errorMessage = "Email Invalid, try again"
        case .weakPassword:
            errorMessage = "Password is weak"
        case .networkError:
            errorMessage = "Lost connection, please try again"
        default:
            errorMessage = "Unknown error. Please try again"
    }
        return errorMessage
    }
    
    func handleLoginError(forCode code: AuthErrorCode) -> String {
        var errorMessage: String
        switch code {
        case .userNotFound:
            errorMessage = "No account found, please sign up."
        case .invalidEmail:
            errorMessage = "Email Invalid, try again"
        case .wrongPassword:
            errorMessage = "Email Address or Password is incorrect."
        case .networkError:
            errorMessage = "Lost connection, please try again"
        default:
            errorMessage = "Unknown error. Please try again"
        }
        return errorMessage
    }
}
