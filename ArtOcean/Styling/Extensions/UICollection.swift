//
//  UICollection.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 26/06/2022.
//

import Foundation
import UIKit

extension UICollectionViewFlowLayout{
	
	static func standardLayout(
		scrollDirection:UICollectionView.ScrollDirection = .vertical,
		size:CGSize = .init(width: UIScreen.main.bounds.width - 20, height: 175),
		interItemSpacing:CGFloat = 12,
		sectionInset:UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
	) -> UICollectionViewFlowLayout{
		let layout:UICollectionViewFlowLayout = .init()
		layout.itemSize = size
		layout.scrollDirection = scrollDirection
		layout.minimumInteritemSpacing = interItemSpacing
		layout.sectionInset = sectionInset
		
		return layout
	}
	
}
