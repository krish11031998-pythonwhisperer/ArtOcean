//
//  SectionbasedData.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 04/06/2022.
//

import Foundation

struct Section:Hashable{
//    static func == (lhs: Section, rhs: Section) -> Bool {
//        return lhs.type == rhs.type
//    }
    
    var type:String?
    var items:[Item]?
}

enum Item:Codable,Hashable{
    case artData(NFTModel)
    case user(User)
}


let NFTArtSection:Section = {
   var section = Section()
    section.type = "ART"
    
    Bundle.main.decodable(NFTDataResponse.self, for: "nft") { result in
        switch result{
        case .success(let data):
            if let ownedNfts = data.ownedNfts{
                section.items = ownedNfts.compactMap({Item.artData($0)})
            }
            
        case .failure(let err):
            print("(DEBUG) Err : ",err.localizedDescription)
        }
    }
    
    return section
}()
