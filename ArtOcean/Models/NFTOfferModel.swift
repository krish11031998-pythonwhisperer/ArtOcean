//
//  NFTOfferModel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation

struct NFTArtOffer:Codable{
    var name:String?
    var percent:String?
    var price:Float?
    var time:Int?
}

typealias NFTArtOffers = [NFTArtOffer]
