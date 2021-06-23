//
//  CountryCodeCell.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 Imran. All rights reserved.
//
import UIKit

class CountryCodeCell: UITableViewCell {

    static let cellIdentifier = String(describing: CountryCodeCell.self)
    
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

    func set(with model: CountriesResponseModelElement) {
        countryNameLbl.text = model.name
        countryCodeLbl.text = model.dialCode
        countryImage.setImage(with: model.filePath)
    }
}
