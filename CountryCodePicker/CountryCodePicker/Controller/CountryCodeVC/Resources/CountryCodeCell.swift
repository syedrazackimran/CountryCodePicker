//
//  CountryCodeCell.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 2ntkh. All rights reserved.
//
import UIKit

class CountryCodeCell: UITableViewCell {

    @IBOutlet var countryCodeLbl: UILabel!
    @IBOutlet var countryNameLbl: UILabel!
    @IBOutlet var countryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        countryImage.layer.cornerRadius = 4
        countryImage.layer.masksToBounds = false
        countryImage.layer.shadowOffset = CGSize(width: CGFloat(1.5), height: CGFloat(1.5))
        countryImage.layer.shadowRadius = 5
        countryImage.layer.shadowOpacity = 0.3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
        // Configure the view for the selected state
    }

}
