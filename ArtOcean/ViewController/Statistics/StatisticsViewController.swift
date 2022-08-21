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


//MARK: - Type

class StatisticsViewController: UIViewController {

//MARK: - Properties

	private lazy var customSlideCollectionView: CustomSelectorDynamicCollectionView = {
		.init(sections: [customArtSection,UserSection])
	}()
	
	private let customArtSection: Section = {
		let nfArtOfferSection = NFTArtOfferSection
		nfArtOfferSection.layout.itemSize = .init(width: .totalWidth, height: 60)
		nfArtOfferSection.layout.sectionInset = .zero
		return nfArtOfferSection
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
		customSlideCollectionView.delegate = self
		view.addSubview(customSlideCollectionView)
		view.setSafeAreaConstraintsToChild(customSlideCollectionView, edgeInsets: .init(top: 16, left: 8, bottom: 0, right: 8))
	}

	private func configNavbar(){
		let searchButton = CustomImageButton(name: .searchOutline, frame: .smallestSqaure, addBG: true, handler: nil)
		let label = CustomLabel(text: "Statistics", size: 22, weight: .bold, color: .appBlackColor, numOfLines: 1,autoLayout: false)
		self.navigationItem.leftBarButtonItem = .init(customView: label)
		self.navigationItem.rightBarButtonItem = .init(customView: searchButton)
	}
}

//MARK: - StatisticViewControllerWithDynamic

extension StatisticsViewController: CustomSelectorDynamicCollectionDelegate {

	func collectionSection(_ section: Section) -> CollectionSection? {
		guard let validItems = section.items else { return nil }
		if section == UserSection {
			let users: [User] = validItems.compactMap { User.decodeFromItem($0) }
			return .init(cells: users.map { CollectionColumn<CustomInfoButtonCollectionCell>(.init($0)) })
		} else if section == NFTArtOfferSection {
			let offers: NFTArtOffers = validItems.compactMap { NFTArtOffer.decodeFromItem($0) }
			return .init(cells: offers.map { offer in
				CollectionColumn<CustomInfoButtonCollectionCell>(.init(offer, withArtImage: true, action: {
					NFTStorage.selectedArt = offer.nft
					NotificationCenter.default.post(name: .showArt, object: nil)
				}))
			})
		} else {
			return nil
		}
	}
}
