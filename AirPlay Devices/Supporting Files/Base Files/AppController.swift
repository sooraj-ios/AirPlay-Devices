//
//  AppController.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import UIKit

class AppStoryBoard {

   static let shared = AppStoryBoard()

    var authentication:UIStoryboard {
       UIStoryboard(name: "Authentication", bundle: nil)
    }

    var dashboard:UIStoryboard {
       UIStoryboard(name: "Dashboard", bundle: nil)
    }
}

class AppController {

    static let shared = AppController()

    // MARK: - Authentication
    var launchScreen: LaunchScreenVC {
       AppStoryBoard.shared.authentication.instantiateViewController(withIdentifier: "LaunchScreenVC_id") as? LaunchScreenVC ?? LaunchScreenVC()
    }

    var login: LoginVC {
       AppStoryBoard.shared.authentication.instantiateViewController(withIdentifier: "LoginVC_id") as? LoginVC ?? LoginVC()
    }

    // MARK: - Dashboard
    var home: HomeVC {
       AppStoryBoard.shared.dashboard.instantiateViewController(withIdentifier: "HomeVC_id") as? HomeVC ?? HomeVC()
    }

    var details: DetailsVC {
       AppStoryBoard.shared.dashboard.instantiateViewController(withIdentifier: "DetailsVC_id") as? DetailsVC ?? DetailsVC()
    }
}
