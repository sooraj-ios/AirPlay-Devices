//
//  LaunchScreenVC.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import UIKit
import FirebaseAuth
class LaunchScreenVC: UIViewController {

    // MARK: - LOADING VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        if !AppUserData.shared.isLoggedIn{
            try? Auth.auth().signOut()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if Network.isAvailable(){
                LoginManager.sharedInstance().checkCurrentUser { loggedIn, errorMessage in
                    if loggedIn {
                        let homeVC = AppController.shared.home
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    } else {
                        let loginVC = AppController.shared.login
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }
                }

//                if let currentUser = Auth.auth().currentUser {
//                    currentUser.getIDToken { (token, error) in
//                        if let error = error {
//                            self.forceLogout()
//                        } else {
//                            let nextVC = AppController.shared.home
//                            self.navigationController?.pushViewController(nextVC, animated: true)
//                        }
//                    }
//                } else {
//                    let nextVC = AppController.shared.login
//                    self.navigationController?.pushViewController(nextVC, animated: true)
//                }
            }else{
                self.forceLogout()
            }
        })
    }

    func forceLogout(){
        LoginManager.sharedInstance().forceLogout()
        AppUserData.shared.clearData()
        let nextVC = AppController.shared.login
        self.navigationController?.pushViewController(nextVC, animated: true)

//        do {
//            try Auth.auth().signOut()
//            AppUserData.shared.clearData()
//            let nextVC = AppController.shared.login
//            self.navigationController?.pushViewController(nextVC, animated: true)
//        } catch let signOutError as NSError {
//            AppUserData.shared.clearData()
//            let nextVC = AppController.shared.login
//            self.navigationController?.pushViewController(nextVC, animated: true)
//        }
    }
}

