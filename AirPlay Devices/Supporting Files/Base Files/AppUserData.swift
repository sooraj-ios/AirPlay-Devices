//
//  AppUserData.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import Foundation

class AppUserData {
    static let shared = AppUserData()

    private let userDefault = UserDefaults.standard

    // MARK: - APP USER DATA
    var userEmail: String {
        get{
            return userDefault.string(forKey: "userEmail") ?? ""
        }
        set(data) {
            userDefault.set(data, forKey: "userEmail")
        }
    }

    var user_token: String {
        get{
            return userDefault.string(forKey: "user_token") ?? ""
        }
        set(data) {
            userDefault.set(data, forKey: "user_token")
        }
    }

    var isLoggedIn : Bool{
        get{
            return userDefault.value(forKey: "isLoggedIn") as? Bool ?? false
        }
        set(status) {
            return userDefault.set(status, forKey: "isLoggedIn")
        }
    }


    func clearData(){
        userEmail = ""
        user_token = ""
        isLoggedIn = false
    }
}

