//
//  NFTOfferModel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation

struct NFTArtOffer:Decodable,Hashable{
    var image:String?
    var name:String?
    var percent:String?
    var price:Float?
    var time:Int?
    var nft:NFTModel?
}

typealias NFTArtOffers = [NFTArtOffer]

let NFTArtOfferSection:Section = {
    var section:Section = .init()
    section.type = "OFFER"
    Bundle.main.decodable(NFTDataResponse.self, for: "nft.json") { result in
        switch result{
        case .success(let nft):
            guard let nfts = nft.ownedNfts else {return}
            section.items = Array(nfts[0...25]).compactMap({NFTArtOffer(image:$0.metadata?.image,name:$0.title,percent:"\(Float.random(in: -50...50))",price:Float.random(in: 0...100),time:Int.random(in: 1...59),nft:$0)}).sorted(by: {$0.time!  < $1.time!}).map({Item.offer($0)})
        case .failure(let err):
            print("(DEBUG) err : ",err.localizedDescription)
        }
    }
    return section
}()
