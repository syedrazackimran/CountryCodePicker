//
//  AppDelegate.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 2ntkh. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var mlocationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    private var currentLocation: CLLocation?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        // Override point for customization after application launch.
        mlocationManager.delegate = self
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.mlocationManager.startUpdatingLocation()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate:CLLocationManagerDelegate {
    //MARK: CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if  locations.count == 0  {
            return
        }
        guard let lastLocation = locations.last else { return }
        currentLocation = lastLocation
        if currentLocation!.coordinate.latitude != 0 {
            CLGeocoder().reverseGeocodeLocation(currentLocation!, completionHandler:{  placemarks, error -> Void in
                if error != nil {
                    return
                }
                guard let placemarks = placemarks else { return }
                if placemarks.count > 0 {
                        guard let countryCode  = placemarks[0].isoCountryCode else { return }
                        guard let locality = placemarks[0].locality else {return}
                        if let filePath = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
                            do {
                                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                guard let totalArray = json as? [[String:String]] else  { return }
                                totalArray.forEach { data in
                                    if let code = data["code"] {
                                        if code == countryCode {
                                            var countryData = [String:String]()
                                            countryData["countrycode"] = data["code"] ?? ""
                                            countryData["countrydialcode"] =  data["dial_code"] ?? ""
                                            countryData["countryname"] =  data["name"] ?? ""
                                            countryData["countycity"] = locality
                                            self.mlocationManager.stopUpdatingLocation()
                                            NotificationCenter.default.post(name:Notification.Name("imran"), object:countryData)
                                            return
                                        }
                                    }
                                }
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                self.mlocationManager.stopUpdatingLocation()
            })
        }
    }
}
