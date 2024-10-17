//
//  ButtonClasses.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 16/10/24.
//

import Foundation
class AppPrimaryButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.setCornerRadius(radius: self.frame.height/2)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
}
