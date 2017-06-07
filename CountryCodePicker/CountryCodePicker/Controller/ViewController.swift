//
//  ViewController.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 2ntkh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CountryCodeDelegate {
    @IBOutlet var lbl_CountryName: UILabel!
    @IBOutlet var lbl_CountryCode: UILabel!
    @IBOutlet var image_CountryFlag: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateLocation(notification:)), name: NSNotification.Name(rawValue: "KImUcurrentCountry"), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK: Update Current Country Details

    func UpdateLocation(notification : Notification) {
        let  countryDict = notification.object as! NSDictionary
        lbl_CountryName.text = (countryDict.object(forKey: "countryname") as! String)
        lbl_CountryCode.text = (countryDict.object(forKey: "countrycode") as! String)
        image_CountryFlag.image = UIImage.init(named: countryDict.object(forKey: "countrycode") as! String)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "KImUcurrentCountry"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCountry" {
            let CountryVC = segue.destination as! CountryCodeVC
            CountryVC.delegate = self
        }
    }
    //MARK: CountryCodeDelegate

    func didselectCounty(country: NSDictionary) {
        print(country)
        lbl_CountryName.text = (country.object(forKey: "name") as! String)
        lbl_CountryCode.text = (country.object(forKey: "dial_code") as! String)
        image_CountryFlag.image = UIImage.init(named: country.object(forKey: "code") as! String)
    }
    

}

