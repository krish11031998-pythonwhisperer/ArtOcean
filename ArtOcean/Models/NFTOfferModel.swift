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

let NFTArtOfferSection:Section = {
	var items: [Item]?
    Bundle.main.decodable(NFTDataResponse.self, for: "nft.json") { result in
        switch result{
        case .success(let nft):
            guard let nfts = nft.ownedNfts else {return}
			items = Array(nfts[0...25]).compactMap(NFTArtOffer.decodeFromNFTModel).sorted().map(NFTArtOffer.encodeToItem)
        case .failure(let err):
            print("(DEBUG) err : ",err.localizedDescription)
        }
    }
	
	let layout: UICollectionViewFlowLayout = .init()
	layout.itemSize = CGSize(width: .totalWidth - 48, height: 50)
	layout.scrollDirection = .vertical
	layout.sectionInset = .init(vertical: .zero, horizontal: 24)
	layout.minimumInteritemSpacing = 12
	layout.minimumLineSpacing = 12
	
	return .init(
		type: "OFFER",
		items: items,
		layout: layout
	)
}()
