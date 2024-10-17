//
//  LoginVM.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import Foundation
import FirebaseAuth
class LoginVM {
    var isLoadingData: Observable<Bool> = Observable(false)
    var showError: Observable<String> = Observable(nil)
    var isLoggedIn: Observable<Bool> = Observable(false)

    func signIn(email:String, password:String){
        if isLoadingData.value ?? true { return }
        isLoadingData.value = true
        LoginManager.sharedInstance().signIn(withEmail: email, password: password) { [weak self] (success, errorMessage) in
            self?.isLoadingData.value = false
            if success {
                self?.isLoggedIn.value = true
            } else if let error = errorMessage {
                self?.showError.value = "User not found. Please check your email and password."
            }
        }
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
//            self?.isLoadingData.value = false
//            if let error = error {
//                self?.showError.value = "User not found. Please check your email and password."
//            } else {
//                if let user = result?.user {
//                    user.getIDToken { (token, error) in
//                        if let token = token {
//                            AppUserData.shared.isLoggedIn = true
//                            AppUserData.shared.userEmail = email
//                            AppUserData.shared.user_token = token
//                            self?.isLoggedIn.value = true
//                        }
//                    }
//                }
//            }
//        }
    }
}
