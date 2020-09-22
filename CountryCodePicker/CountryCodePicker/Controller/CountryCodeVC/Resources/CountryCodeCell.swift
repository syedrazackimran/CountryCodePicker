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
        setupView()
    }

    private func setupView() {
        countryImage.layer.cornerRadius = 4
        countryImage.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected == true ? .checkmark : .none
        // Configure the view for the selected state
    }

}
