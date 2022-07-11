//
//  CollectionColumn.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 06/07/2022.
//

import Foundation
import UIKit

typealias ConfigurableCollectionCell = UICollectionViewCell & Configurable

protocol CellProviderColumn{
    var cellModel: Any { get }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func didSelect(_ collectionView: UICollectionView)
    var itemSize:CGSize { get }
}

class CollectionColumn<Cell:ConfigurableCollectionCell>:CellProviderColumn{
	
    var cellModel: Any { model }
    
    var model:Cell.Model
        
    var itemSize: CGSize { Cell.itemSize }
    
	init(_ model:Cell.Model){
        self.model = model
    }

	
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:Cell = collectionView.dequeueCell(for: indexPath)
        cell.configureCell(with: model)
        return cell
    }
    
    func didSelect(_ collectionView: UICollectionView) {
        guard let actionableModel = model as? ActionProvider else {return}
        actionableModel.action?()
    }
}

