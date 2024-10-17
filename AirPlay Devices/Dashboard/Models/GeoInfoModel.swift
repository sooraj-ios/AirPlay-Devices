//
//  GeoInfoModel.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 15/10/24.
//

import Foundation

struct GeoInfoModel: Decodable {
    let ip: String
    let hostname: String
    let city: String
    let region: String
    let country: String
    let loc: String
    let org: String
    let postal: String
    let timezone: String
    let readme: String
}

struct IPAddressModel: Decodable {
    let ip: String
}
