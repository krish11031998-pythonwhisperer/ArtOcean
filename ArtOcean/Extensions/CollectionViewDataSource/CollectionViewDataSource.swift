//
//  CollectionViewDataSource.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 06/07/2022.
//

import Foundation
import UIKit

class CollectionDataSource:NSObject{
    
    var columns:[CellProviderColumn]
	let layout:UICollectionViewFlowLayout
	private let height:CGFloat
	private let width:CGFloat
    
	init(
		columns:[CellProviderColumn],
		layout:UICollectionViewFlowLayout,
		width: CGFloat,
		height: CGFloat
	){
        self.columns = columns
		self.layout = layout
		self.width = width
		self.height = height
	}
	
	var collectionHeight: CGFloat { height == .zero ? layout.itemSize.height + 20 : height }
	var collectionWidth: CGFloat { width == .zero ? layout.itemSize.width : width }
}


extension CollectionDataSource:UICollectionViewDataSource,UICollectionViewDelegate{
    
	func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return columns.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		columns[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		columns[indexPath.row].didSelect(collectionView)
    }
}

