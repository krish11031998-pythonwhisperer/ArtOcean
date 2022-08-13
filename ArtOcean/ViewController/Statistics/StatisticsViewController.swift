//
//  StatisticsViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit
//MARK: - Type

class StatisticsViewController: UIViewController {
	
//MARK: - Properties
	
	private let customSlideCollectionView: CustomSelectorDynamicCollectionView = {
		.init(sections: [NFTArtOfferSection,UserSection])
	}()
	
//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configNavbar()
		setupUI()
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
			return .init(cells: validItems.map { CollectionColumn<StatisticRankingCollectionViewCell>($0) })
		} else if section == NFTArtOfferSection {
			return .init(cells: validItems.map { CollectionColumn<StatisticActivityCollectionViewCell>($0) })
		} else {
			return nil
		}
	}
}


