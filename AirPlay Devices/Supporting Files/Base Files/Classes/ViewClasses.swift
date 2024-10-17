//
//  ViewClasses.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 15/10/24.
//

import UIKit

class CurvedShadowView: UIView {
   required init?(coder: NSCoder) {
      super.init(coder: coder)
      self.setCornerRadius(radius: 8)
       self.setShadow()
   }
}
