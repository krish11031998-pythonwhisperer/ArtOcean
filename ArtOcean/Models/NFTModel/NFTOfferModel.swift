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
	
	static func decodeFromItem(_  item: Item) -> Self? {
		switch item {
		case .offer(let nFTArtOffer):
			return nFTArtOffer
		default:
			return nil
		}
	}
}

extension Array where Element == NFTArtOffer {
	
	func sorted() -> [Self.Element] {
		sorted(by: {$0.time!  < $1.time!})
	}
}

typealias NFTArtOffers = [NFTArtOffer]

extension NFTArtOffer {
	
	var tableCell: CellProvider { TableRow<CustomInfoButtonCell>(.init(self, withArtImage: false)) }
	var collectionCell: CollectionCellProvider { CollectionColumn<CustomInfoButtonCollectionCell>(.init(self, withArtImage: false)) }
	var buttonView: CustomInfoButton {
		let button = CustomInfoButton()
		button.updateUIButton(.init(self, withArtImage: true, action: {
			NFTStorage.selectedArt = nft
		}))
		return button
	}
}

extension NFTArtOffers {
	
	var rows: [CellProvider] { map(\.tableCell) }
	var collectionRows: [CollectionCellProvider] { map(\.collectionCell) }
}

extension CustomInfoButtonModel {
	
	init(_ offer: NFTArtOffer, withArtImage: Bool = false, edges: UIEdgeInsets = .init(vertical: 10, horizontal: 16), action: Callback? = nil) {
		var img: UIImage? = nil
		var style: ImageStyle
		var url: String? = nil

		if !withArtImage {
			let initialImage: CustomLabel = .init(size: .squared(40))
			offer.name?.initials().styled(font: .bold, color: .white, size: 14).renderInto(target: initialImage)
			initialImage.backgroundColor = .appGrayColor
			initialImage.textAlignment = .center
			img = initialImage.snapshot
			style = .circle(.squared(40))
		} else {
			style = .rounded(8)
			url = offer.image
		}
		
		self.init(
			leadingImg: img,
			title: offer.name?.replace().body2Medium(),
			subTitle: "Expired in \(offer.time?.toString() ?? "0") days".body3Regular(),
			infoTitle: offer.price?.toString().body2Medium(),
			infoSubTitle: offer.percent?.body3Regular(),
			leadingImageUrl: url,
			style: style,
			leadingImgSize: .squared(40),
			edges: edges
		) {
				NFTStorage.selectedArt = offer.nft
				NotificationCenter.default.post(name: .showArt, object: nil)
			}
	}
	
	
	
}
