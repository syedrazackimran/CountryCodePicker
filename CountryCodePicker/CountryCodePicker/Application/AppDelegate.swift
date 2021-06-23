//
//  AppDelegate.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 Imran. All rights reserved.
//


import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var mlocationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
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
        self.mlocationManager.requestLocation()
        //self.mlocationManager.startUpdatingLocation()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//MARK:- Location Manager Delegate
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count != 0 else { return }
        guard let lastLocation = locations.last else { return }
        if lastLocation.coordinate.latitude != 0 {
            CLGeocoder().reverseGeocodeLocation(lastLocation) { [weak self] placemarks, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    // get error, and stop action
                    strongSelf.mlocationManager.stopUpdatingLocation()
                    print("ERROR :\(error.localizedDescription)")
                    return
                }
                guard let placemarks = placemarks, placemarks.count > 0 else { return }
                guard let countryCode  = placemarks.first?.isoCountryCode else { return }
                guard let locality = placemarks.first?.locality else { return }
                Helper.fetchDataFromBundle { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success(let responseModel):
                        for (_, element) in responseModel.enumerated() {
                            if countryCode == element.code {
                                let filePath = Helper.getAssetsBundlePath(with: "Images",
                                                                          fileName: element.code,
                                                                          fileExtension: ".png")
                                let countryDetail = CountriesResponseModelElement(name: element.name,
                                                                                  dialCode: element.dialCode,
                                                                                  code: element.code,
                                                                                  locality: locality,
                                                                                  filePath: filePath)
                                strongSelf.mlocationManager.stopUpdatingLocation()
                                NotificationCenter.default.post(name: .didFetchLocationNotification, object: countryDetail)
                                return
                            }
                        }
                    case .failure(let error):
                        print("ERROR:", error.localizedDescription)
                        strongSelf.mlocationManager.stopUpdatingLocation()
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


