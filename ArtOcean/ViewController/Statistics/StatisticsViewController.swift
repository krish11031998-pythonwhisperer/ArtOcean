//
//  StatisticsViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

//MARK: - Definations

enum Sections: String {
	case Offers
	case Users
	
	var slideSelectorItem: SlideSelectorItem {
		switch self {
		case .Offers:
			return .init(title: rawValue, image: .Catalogue.menu.image)
		case .Users:
			return .init(title: rawValue, image: .Catalogue.user.image)
		}
	}
	
}

extension User {
	var userCollectionCell: CollectionCellProvider {
		CollectionColumn<CustomInfoButtonCollectionCell>(.init(self, edges: .init(vertical: 10, horizontal: 5)))
	}
}

extension NFTArtOffer {
	var artCollectionCell: CollectionCellProvider {
		CollectionColumn<CustomInfoButtonCollectionCell>(.init(self, withArtImage: true, edges: .init(vertical: 10, horizontal: 5)))
	}
}

//MARK: - Type

class StatisticsViewController: UIViewController {

//MARK: - Properties

	private lazy var customSlideCollectionView: CustomSelectorDynamicCollectionView = {
		.init(sections: [customArtSection,customUserSection])
	}()
	
	private let customArtSection: Section = {
		var section = NFTArtOfferSection
		section.layout.itemSize = .init(width: .totalWidth - 16, height: 60)
		section.layout.sectionInset = .zero
		section.layout.minimumLineSpacing = 0
		section.collectionCellProvider = section.items?.compactMap(\.nftOffer?.artCollectionCell)
		return section
	}()
	
	private let customUserSection: Section = {
		var section = UserSection
		section.layout.itemSize.width -= 16
		section.layout.sectionInset = .zero
		section.layout.minimumLineSpacing = 0
		section.collectionCellProvider = section.items?.compactMap(\.nftUser?.userCollectionCell)
		return section
	}()

//MARK: - Overriden Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		configNavbar()
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if self.navigationController?.navigationBar.frame.origin.y != .zero {
			self.navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
		}
		
	}

//MARK: - Protected Methods

	private func setupUI() {
		view.addSubview(customSlideCollectionView)
		view.setSafeAreaConstraintsToChild(customSlideCollectionView, edgeInsets: .init(top: 16, left: 8, bottom: 0, right: 8))
		view.backgroundColor = .surfaceBackground
	}

	private func configNavbar(){
		let searchButton = CustomImageButton(name: .searchOutline, frame: .smallestSqaure, addBG: true, handler: nil)
		let label = UILabel()
		"Statistics".heading3().renderInto(target: label)
		navigationItem.leftBarButtonItem = .init(customView: label)
		navigationItem.rightBarButtonItem = .init(customView: searchButton)
		setupStatusBar()
	}
}
