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
	let selectorItem: SlideSelectorItem?
	
	init(
		type: SectionType?,
		items: [Item]?,
		layout: UICollectionViewFlowLayout = .standardFlow,
		selectorItem: SlideSelectorItem? = nil
	) {
		self.type = type
		self.items = items
		self.layout = layout
		self.selectorItem = selectorItem
	}
}

//MARK: - Hashable

extension Section: Hashable {
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(type)
	}
}

struct Empty: Hashable,Codable {
	
	let id: String
	
	init(id: String = UUID().uuidString) {
		self.id = id
	}
}

enum Item:Decodable,Hashable{
    case artData(NFTModel)
    case user(User)
    case offer(NFTArtOffer)
	case empty(Empty)
}

protocol ConfirgurableCell:UICollectionViewCell{
    static var identifier:String {get}
    func configure(_ data:Item)
}

