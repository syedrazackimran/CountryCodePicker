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
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var mlocationManager = CLLocationManager()
    var currentLocation : CLLocation?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //MARK: CLLocationManager init
        mlocationManager.startUpdatingLocation()
        mlocationManager.requestAlwaysAuthorization()
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
        //MARK: CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        
        if  locations.count == 0  {
            return
        }
        if nil != currentLocation && (locations.last?.isEqual(currentLocation))! {
            return
        }
        
        currentLocation = locations.last
        if currentLocation?.coordinate.latitude != 0 {
            geoCoder.reverseGeocodeLocation(currentLocation!, completionHandler: {  (placemarks, error) -> Void in
                if error != nil {
                    return
                }
                if placemarks != nil {
                    if (placemarks?.count)! > 0 {
                        let countryCode  = placemarks?[0].isoCountryCode
                        let locality = placemarks?[0].locality
                        if let path = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
                            do {
                                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                                do {
                                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) //as! NSDictionary
                                    let totalArray = (jsonResult as! [AnyObject])
                                    var code: String?
                                    for  i in totalArray {
                                        code = i ["code"] as? String
                                        if code == countryCode {
                                            let CountryDict = NSMutableDictionary()
                                            CountryDict.setObject(i["code"], forKey: "countrycode" as NSCopying)
                                            CountryDict.setObject(i["dial_code"], forKey: "countrydialcode" as NSCopying)
                                            CountryDict.setObject(i["name"], forKey: "countryname" as NSCopying)
                                            CountryDict.setObject(locality!, forKey: "countycity" as NSCopying)
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KImUcurrentCountry"), object: CountryDict)
                                            self.mlocationManager.stopUpdatingLocation()
                                            break
                                        }
                                    }
                                    
                                } catch {}
                            } catch {}
                        }
                        
                    }
                }
                self.mlocationManager.stopUpdatingLocation()
            })
        }
    }


}

