//
//  CollectionSection.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 06/08/2022.
//

import Foundation
import UIKit

typealias CollectionSectionDataSource = NSObject & UICollectionViewDelegate & UICollectionViewDataSource

class CollectionSection: CollectionSectionDataSource {
	
	let headerView: UIView?
	let cells: [CollectionCellProvider]
	
	
	init(
		headerView: UIView? = nil,
		cells: [CollectionCellProvider]
	) {
		self.headerView = headerView
		self.cells = cells
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { cells.count }
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { cells[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath) }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = cells[indexPath.row]
		cell.didSelect(collectionView, indexPath: indexPath)
	}
	
}


