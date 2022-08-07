//
//  SectionbasedData.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 04/06/2022.
//

import Foundation
import UIKit

typealias SectionType = String

struct Section {
	
    let type: SectionType?
    let items: [Item]?
	let layout: UICollectionViewFlowLayout
	
	init(type: SectionType?, items: [Item]?, layout: UICollectionViewFlowLayout = .standardFlow) {
		self.type = type
		self.items = items
		self.layout = layout
	}
}

extension Section: Hashable {
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(type)
	}
}

enum Item:Decodable,Hashable{
    case artData(NFTModel)
    case user(User)
    case offer(NFTArtOffer)
}

protocol ConfirgurableCell:UICollectionViewCell{
    static var identifier:String {get}
    func configure(_ data:Item)
}


let NFTArtSection:Section = {
	var artItems: [Item]?
    
    Bundle.main.decodable(NFTDataResponse.self, for: "nft.json") { result in
        switch result{
        case .success(let data):
            if let ownedNfts = data.ownedNfts{
                let items = ownedNfts.compactMap({Item.artData($0)})
                artItems = items.count < 50 ? items : Array(items[0..<50])
            }
            
        case .failure(let err):
            print("(DEBUG) Err : ",err.localizedDescription)
        }
    }
    
	let layout: UICollectionViewFlowLayout = .standardVGridFlow
	layout.itemSize.width = (.totalWidth - 48).half() - layout.minimumInteritemSpacing
	layout.sectionInset = .init(vertical: 10, horizontal: 10)
	
	return .init(type: "ART", items: artItems, layout: layout)
}()
