//
//  NFTOfferModel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit


struct NFTArtOffer:Decodable,Hashable{	
    var image:String?
    var name:String?
    var percent:String?
    var price:Float?
    var time:Int?
    var nft:NFTModel?
}

extension NFTArtOffer {
	
	static func decodeFromNFTModel(_ model: NFTModel) -> Self {
		.init(
			image: model.metadata?.image,
			name: model.title,
			percent: "\(Float.random(in: -50...50))",
			price: Float.random(in: 0...100),
			time: Int.random(in: 1...59),
			nft: model
		)
	}
	
	static func encodeToItem(_ offer: NFTArtOffer) -> Item {
		Item.offer(offer)
	}
}

extension Array where Element == NFTArtOffer {
	
	func sorted() -> [Self.Element] {
		sorted(by: {$0.time!  < $1.time!})
	}
}

typealias NFTArtOffers = [NFTArtOffer]

