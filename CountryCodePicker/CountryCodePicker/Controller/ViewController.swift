//
//  ViewController.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 2ntkh. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var countryCodeLabel: UILabel!
    @IBOutlet var countryFlagImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
//      
        NotificationCenter.default.addObserver(self, selector:#selector(self.UpdateLocation(notification: )), name:Notification.Name(notificationName), object:nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Update Current Country Details
    @objc
    private func UpdateLocation(notification: Notification) {
        guard let  countryDict = notification.object as?  [String:String] else { return }
        guard let dialCode = countryDict["countryDialCode"],
              let countryName = countryDict["countryName"],
              let countryCode = countryDict["countryCode"] else { return }
        countryCodeLabel.text = dialCode
        countryNameLabel.text = "\(countryName) - \(countryCode)"
        countryFlagImageView.image = UIImage(named: countryCode)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationName), object: nil)
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


extension ViewController: CountryCodeDelegate {
    //MARK: CountryCodeDelegate

    func didselectCounty(country: [String:String]) {
        guard let countryName = country["name"],
              let dialCode = country["dial_code"],
              let countryCode = country["code"] else { return }
        countryNameLabel.text = "\(countryName) - \(countryCode)"
        countryCodeLabel.text = dialCode
        countryFlagImageView.image = UIImage(named: countryCode)
    }

}
