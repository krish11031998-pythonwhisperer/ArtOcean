//
//  CollectionViewDataSource.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 06/07/2022.
//

import Foundation
import UIKit

class CollectionDelegateAndDataSource:NSObject{
    
    var columns:[CellProviderColumn]
	var layout:UICollectionViewFlowLayout
    
	init(columns:[CellProviderColumn],layout:UICollectionViewFlowLayout){
        self.columns = columns
		self.layout = layout
    }
}


extension CollectionDelegateAndDataSource:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return columns.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        columns[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        columns[indexPath.row].didSelect(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		columns[indexPath.row].itemSize == .zero ? layout.itemSize : columns[indexPath.row].itemSize
    }

}

