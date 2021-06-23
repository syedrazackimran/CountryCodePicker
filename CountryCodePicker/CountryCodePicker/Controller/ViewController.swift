//
//  ViewController.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 Imran. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var countryCodeLabel: UILabel!
    @IBOutlet var countryFlagImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(self.UpdateLocation(_:)),
                                               name: .didFetchLocationNotification, object:nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Update Current Country Details
    @objc
    private func UpdateLocation(_ notification: Notification) {
        guard let countryResponseModel = notification.object as? CountriesResponseModelElement else { return }
        countryCodeLabel.text = countryResponseModel.dialCode
        countryNameLabel.text = "\(countryResponseModel.name) - \(countryResponseModel.code)"
        countryFlagImageView.setImage(with: countryResponseModel.filePath)
        NotificationCenter.default.removeObserver(self, name: .didFetchLocationNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCountry" {
            guard let countryVC = segue.destination as? CountryCodeVC else { return }
            countryVC.delegate = self
        }
    }
}


//MARK: CountryCodeDelegate
extension ViewController: CountryCodeDelegate {

    func didselectCounty(model: CountriesResponseModelElement) {
        countryNameLabel.text = "\(model.name) - \(model.code)"
        countryCodeLabel.text = model.dialCode
        countryFlagImageView.setImage(with: model.filePath)
    }

}
