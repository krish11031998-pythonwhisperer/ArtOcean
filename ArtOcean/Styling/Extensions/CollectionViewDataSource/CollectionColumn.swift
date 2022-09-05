//
//  CollectionColumn.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 06/07/2022.
//

import Foundation
import UIKit

typealias ConfigurableCollectionCell = UICollectionViewCell & Configurable

protocol CollectionCellProvider{
    var cellModel: Any { get }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	func didSelect(_ collectionView: UICollectionView, indexPath: IndexPath)
}

class CollectionColumn<Cell:ConfigurableCollectionCell>: CollectionCellProvider{
	
    var cellModel: Any { model }
    
    var model:Cell.Model
	
	init(_ model:Cell.Model){
        self.model = model
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:Cell = collectionView.dequeueCell(for: indexPath)
        cell.configureCell(with: model)
        return cell
    }
    
    func didSelect(_ collectionView: UICollectionView, indexPath: IndexPath) {
        guard let actionableModel = model as? ActionProvider else {return}
		let cell = collectionView.cellForItem(at: indexPath)
		cell?.animate(.scaleInOut(duration: 0.1),completion: {
			actionableModel.action?()
		})
    }
}

