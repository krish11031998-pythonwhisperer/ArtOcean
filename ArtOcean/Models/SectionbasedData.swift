//
//  SectionbasedData.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 04/06/2022.
//

import Foundation
import UIKit

typealias SectionType = String

struct Section:Hashable{
    var type:SectionType?
    var items:[Item]?
}

enum Item:Codable,Hashable{
    case artData(NFTModel)
    case user(User)
}

protocol ConfirgurableCell:UICollectionViewCell{
    static var identifier:String {get}
    func configure(_ data:Item)
}


let NFTArtSection:Section = {
   var section = Section()
    section.type = "ART"
    
    Bundle.main.decodable(NFTDataResponse.self, for: "nft.json") { result in
        switch result{
        case .success(let data):
            if let ownedNfts = data.ownedNfts{
                let items = ownedNfts.compactMap({Item.artData($0)})
                section.items = items.count < 50 ? items : Array(items[0..<50])
            }
            
        case .failure(let err):
            print("(DEBUG) Err : ",err.localizedDescription)
        }
    }
    
    return section
}()
