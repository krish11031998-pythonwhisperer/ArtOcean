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
		.init(sections: [customArtSection,customUserSection])
	}()
	
	private let customArtSection: Section = {
		let section = NFTArtOfferSection
		section.layout.itemSize = .init(width: .totalWidth, height: 60)
		section.layout.sectionInset = .zero
		section.layout.minimumLineSpacing = 0
		return section
	}()
	
	private let customUserSection: Section = {
		let section = UserSection
		section.layout.sectionInset = .zero
		section.layout.minimumLineSpacing = 0
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
		customSlideCollectionView.delegate = self
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

//MARK: - StatisticViewControllerWithDynamic

extension StatisticsViewController: CustomSelectorDynamicCollectionDelegate {

	func collectionSection(_ section: Section) -> CollectionSection? {
		guard let validItems = section.items else { return nil }
		if section == UserSection {
			return .init(cells: validItems.compactMap(\.nftUser?.collectionCell))
		} else if section == NFTArtOfferSection {
			return .init(cells: validItems.compactMap(\.nftOffer?.collectionCell))
		}
		return nil
	}
}
