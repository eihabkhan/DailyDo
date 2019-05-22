//
//  AuthService.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let shared = AuthService()
    
    var currentUserUID = Auth.auth().currentUser?.uid
    
    func updateUID(uid: String) {
        currentUserUID = uid
    }
}
