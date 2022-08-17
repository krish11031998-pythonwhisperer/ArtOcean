//
//  SectionTestData.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 07/08/2022.
//

import UIKit

//MARK: - NFTArtSection Section
let NFTArtSection: Section = {
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
	layout.itemSize.width = (.totalWidth - 28).half() - layout.minimumInteritemSpacing
	layout.sectionInset = .init(vertical: 10)
	
	return .init(type: "ART", items: artItems, layout: layout, selectorItem: .init(title: "Items", image: .Catalogue.viewGrid.image))
}()

//MARK: - NFTArtOfferSection Section

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
	layout.itemSize = CGSize(width: .totalWidth - 10, height: 60)
	layout.scrollDirection = .vertical
	layout.sectionInset = .init(horizontal: 5)
	layout.minimumInteritemSpacing = 12
	layout.minimumLineSpacing = 12
	
	return .init(
		type: "OFFER",
		items: items,
		layout: layout,
		selectorItem: .init(title: "Offers", image: .Catalogue.user.image)
	)
}()


//MARK: - StatisticArtSection Section

let UserSection:Section = {
	let layout: UICollectionViewFlowLayout = .init()
	layout.itemSize = CGSize(width: .totalWidth, height: 60)
	layout.scrollDirection = .vertical
	layout.sectionInset = .init(horizontal: 0)
	layout.minimumInteritemSpacing = 12
	layout.minimumLineSpacing = 12
	
	return Section(type: "USER", items: testUser.compactMap{ Item.user($0) },layout: layout, selectorItem: .init(title: "User", image: .Catalogue.user.image))
}()
