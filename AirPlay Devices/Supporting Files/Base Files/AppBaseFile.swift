//
//  AppBaseFile.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 16/10/24.
//

import Foundation
final class AppBaseFile {
    static let shared = AppBaseFile()

    //MARK: BASE URLS
    let baseURL = "https://ipinfo.io"
    let baseURL2 = "https://api.ipify.org"

    //MARK: ENDPOINTS
    let getGeoInfo = "?format=json"
}
