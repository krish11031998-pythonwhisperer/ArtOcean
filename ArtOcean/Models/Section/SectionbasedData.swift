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
	let tableCellProvider: [CellProvider]?
	var collectionCellProvider: [CollectionCellProvider]?
	let selectorItem: SlideSelectorItem?
	
	init(
		type: SectionType?,
		items: [Item]?,
		layout: UICollectionViewFlowLayout = .standardFlow,
		selectorItem: SlideSelectorItem? = nil,
		tableCellProvider: [CellProvider]? = nil,
		collectionCellProvider: [CollectionCellProvider]? = nil
	) {
		self.type = type
		self.items = items
		self.layout = layout
		self.selectorItem = selectorItem
		self.tableCellProvider = tableCellProvider
		self.collectionCellProvider = collectionCellProvider
	}
}

//MARK: - Hashable

extension Section: Hashable {
	static func == (lhs: Section, rhs: Section) -> Bool {
		lhs.type == rhs.type
	}
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
	
	var nftArtData: NFTModel? {
		switch self {
		case .artData(let nftModel):
			return nftModel
		default:
			return nil
		}
	}
	
	var nftUser: User? {
		switch self {
		case .user(let user):
			return user
		default:
			return nil
		}
	}
	
	var nftOffer: NFTArtOffer? {
		switch self {
		case .offer(let offer):
			return offer
		default: return nil
		}
	}
}

protocol ConfirgurableCell:UICollectionViewCell{
    static var identifier:String {get}
    func configure(_ data:Item)
}

