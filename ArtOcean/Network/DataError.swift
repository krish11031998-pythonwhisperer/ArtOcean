//
//  DataError.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import Foundation
enum DataError:String,Error{
    case invalidURL = "The URL is empty/invalid and therefore no httpRequest commenced"
    case responseStatusInvalid = "The status Code for the response is not SUCCESS"
    case dataParse = "The Data to parse is in the incorrect format"
    case dataMissing = "The data you wish to parse is missing"
    case noData = "No Data"
    case noResponse = "No Response"
}
