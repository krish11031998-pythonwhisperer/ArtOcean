//
//  UICollectionLayoutExtension.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 10/07/2022.
//

import Foundation
import UIKit

extension UICollectionViewFlowLayout {
	
	static var standardFlow: UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = .init(width: 175, height: 200)
		layout.scrollDirection = .horizontal
		layout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 10
		return layout
	}
	
	static func standardFlowWithSize(_ size:CGSize) -> UICollectionViewFlowLayout {
		let layout: UICollectionViewFlowLayout = .standardFlow
		layout.itemSize = size
		return layout
	}
	
	static var standardGridFlow: UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 116)
		layout.scrollDirection = .horizontal
		layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 24
		return layout
	}
	
}
