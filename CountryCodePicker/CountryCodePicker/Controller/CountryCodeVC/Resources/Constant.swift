//
//  Constant.swift
//  CountryCodePicker
//
//  Created by Imran on 18/06/21.
//  Copyright © 2021 Imran. All rights reserved.
//

import Foundation
import UIKit

//Don't not change It's Important
let bundleName = "CountryData"
let countryCodefileName = "CountryCodes"

//MARK:- Helper 
struct Helper {
    /// Fetch Data From Bundel
    /// - Parameter completion: Completion Restul Type of Struct and Error
    static func fetchDataFromBundle(completion: @escaping(Result<CountriesResponseModel, Error>) -> Void) {
        guard let countryCodePath = Helper.getAssetsBundlePath(with: "Data", fileName: countryCodefileName, fileExtension: ".json") else { return }
        do {
            let data = try Data(contentsOf: countryCodePath, options: .mappedIfSafe)
            var reponseModel = try JSONDecoder().decode(CountriesResponseModel.self, from: data)
            for(index, var element) in reponseModel.enumerated() {
                let filePath = Helper.getAssetsBundlePath(with: "Images", fileName: element.code, fileExtension: ".png")
                element.filePath = filePath
                reponseModel[index].filePath = element.filePath
            }
            completion(.success(reponseModel))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    /// Getting Assets from Bundle
    /// - Parameters:
    ///   - folderName: Bundle have Folder, Folder name String
    ///   - fileName: filename to fetch String
    ///   - fileExtension: file Extension String `.png` or `.json`
    /// - Returns: returning URL file path Optional nil
    static func getAssetsBundlePath(with folderName: String,
                                    fileName:String,
                                    fileExtension: String) -> URL? {
        guard let bundlePath = Bundle.main.url(forResource: bundleName, withExtension: "bundle"),
              let bundleFolder = Bundle(url: bundlePath)?.url(forResource: folderName, withExtension: nil) else {
            return nil
        }
        let bundleFile = bundleFolder.appendingPathComponent(fileName + fileExtension)
        return bundleFile
    }
}


//MARK:- UIImageView Extension
extension UIImageView {
    /// Load Image From Local path
    /// - Parameter path: filepath URL
    func setImage(with path: URL?) {
        DispatchQueue.main.async {
            do {
                guard let path = path else { return }
                let imageData = try Data(contentsOf: path)
                let image = UIImage(data: imageData)
                self.image = image
            } catch let error {
                print("ERROR: \(error)")
            }
        }
    }
}


//MARK:- Notificatio Name Extension
extension Notification.Name {
    static let didFetchLocationNotification = Notification.Name("didFetchLocationData")
}
