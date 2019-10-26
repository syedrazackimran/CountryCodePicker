//
//  ViewController.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 2ntkh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CountryCodeDelegate {
    @IBOutlet var lbl_CountryName: UILabel!
    @IBOutlet var lbl_CountryCode: UILabel!
    @IBOutlet var image_CountryFlag: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
//      
        NotificationCenter.default.addObserver(self, selector:#selector(self.UpdateLocation(notification: )), name:Notification.Name("imran"), object:nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Update Current Country Details
    @objc private func UpdateLocation(notification: Notification) {
        guard let  countryDict = notification.object as?  [String:String] else { return }
        lbl_CountryName.text = countryDict["countrydialcode"]
        lbl_CountryCode.text = countryDict["countrycode"]
        image_CountryFlag.image = UIImage.init(named: countryDict["countrycode"] ?? "")
        NotificationCenter.default.removeObserver(self, name:Notification.Name("imran"), object:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCountry" {
            guard let CountryVC = segue.destination as? CountryCodeVC else { return }
            CountryVC.delegate = self
        }
    }
    //MARK: CountryCodeDelegate

    func didselectCounty(country: [String:String]) {
        lbl_CountryName.text = country["name"]
        lbl_CountryCode.text = country["dial_code"]
        image_CountryFlag.image = UIImage.init(named: country["code"] ?? "")
    }
}

