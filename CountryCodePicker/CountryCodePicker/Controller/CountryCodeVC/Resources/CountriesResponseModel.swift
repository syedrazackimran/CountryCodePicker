//
//  CountriesResponseModel.swift
//  CountryCodePicker
//
//  Created by Imran on 23/06/21.
//  Copyright © 2021 Imran. All rights reserved.
//

import Foundation

// MARK: - CountriesResponseModelElement
struct CountriesResponseModelElement: Codable {
    var name, dialCode, code: String
    var locality: String?
    var filePath: URL?
    
    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
    }
}

typealias CountriesResponseModel = [CountriesResponseModelElement]
