//
//  DeviceTVC.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import UIKit

class DeviceTVC: UITableViewCell {
    @IBOutlet weak var deviceNameLbl: UILabel!
    @IBOutlet weak var deviceIPaddressLbl: UILabel!
    @IBOutlet weak var deviceStatusLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
