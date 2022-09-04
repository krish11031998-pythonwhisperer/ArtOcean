//
//  UICollectionLayoutExtension.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 10/07/2022.
//

import Foundation
import UIKit

extension UICollectionViewFlowLayout {
	
	convenience init(
		itemSize:CGSize,
		scrollDirection:UICollectionView.ScrollDirection = .vertical,
		sectionInset:UIEdgeInsets = .zero,
		interitemSpacing:CGFloat = 10,
		lineSpacing:CGFloat = 10
	) {
		self.init()
		self.itemSize = itemSize
		self.scrollDirection = scrollDirection
		self.sectionInset = sectionInset
		self.minimumInteritemSpacing = interitemSpacing
		self.minimumLineSpacing = lineSpacing
	}
	
	static var standardFlow: UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = .init(width: 175, height: 200)
		layout.scrollDirection = .horizontal
		layout.sectionInset = .init(vertical: 0, horizontal: 16)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 10
		return layout
	}
	
	static func standardFlowWithSize(_ size:CGSize) -> UICollectionViewFlowLayout {
		let layout: UICollectionViewFlowLayout = .standardFlow
		layout.itemSize = size
		return layout
	}
	
	
	static var standardHGridFlow: UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = .init(width: 135, height: 250)
		layout.scrollDirection = .horizontal
		layout.sectionInset = .init(vertical: 0, horizontal: 16)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 24
		return layout
	}
	
	static var standardVGridFlow: UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.sectionInset = .init(vertical: 0, horizontal: 16)
		layout.minimumInteritemSpacing = 10
		layout.minimumLineSpacing = 24
		layout.itemSize = .init(width: .totalWidth.half - layout.minimumInteritemSpacing.multiple(factor: 2), height: 250)
		return layout
	}
	
}
