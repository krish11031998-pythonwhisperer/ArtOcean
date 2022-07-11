//
//  CollectionViewCell.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 05/07/2022.
//

import Foundation
import UIKit


class CollectionViewTableCell:ConfigurableCell{

	private var padding:CGFloat = .zero
	
	init(withPadding:Bool = false){
		self.padding = withPadding ? 10 : .zero
		super.init(style: .default, reuseIdentifier: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func buildCollection(_ layout:UICollectionViewFlowLayout) -> UICollectionView{
		let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collection.showsHorizontalScrollIndicator = false
		collection.setFrameConstraints(width: UIScreen.main.bounds.width, height: layout.itemSize.height + padding)
		return collection
	}
	
	func configureCell(with model: CollectionDelegateAndDataSource) {
		let collection = buildCollection(model.layout)
		contentView.addSubview(collection)
		contentView.setContraintsToChild(collection, edgeInsets: .zero)
		collection.reload(with: model)
	}
	
}
