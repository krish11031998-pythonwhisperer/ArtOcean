//
//  CollectionViewDataSource.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 06/07/2022.
//

import Foundation
import UIKit

class CollectionDataSource:NSObject{
    
	let sections:[CollectionSection]
	let layout:UICollectionViewFlowLayout
	let enableScroll: Bool
	private let height:CGFloat
	private let width:CGFloat
    
	init(
		sections:[CollectionSection],
		layout:UICollectionViewFlowLayout,
		enableScroll: Bool = true,
		width: CGFloat = .zero,
		height: CGFloat = .zero
	){
        self.sections = sections
		self.layout = layout
		self.width = width
		self.height = height
		self.enableScroll = enableScroll
	}
	
	convenience init(
		columns:[CollectionCellProvider],
		layout:UICollectionViewFlowLayout,
		enableScroll: Bool = true,
		width: CGFloat = .zero,
		height: CGFloat = .zero
	){
		self.init(sections: [.init(cells: columns)], layout: layout, enableScroll: enableScroll, width: width, height: height)
	}
	
	var collectionHeight: CGFloat? { height == .zero ? layout.itemSize.height + 20 : height != .infinity ? height : nil }
	var collectionWidth: CGFloat? { width == .zero ? layout.itemSize.width : width != .infinity ? width : nil }
}


extension CollectionDataSource:UICollectionViewDataSource,UICollectionViewDelegate{
    
	func numberOfSections(in collectionView: UICollectionView) -> Int { sections.count }
    
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { sections[section].cells.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		sections[indexPath.section].cells[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		sections[indexPath.section].cells[indexPath.row].didSelect(collectionView, indexPath: indexPath)
    }
}

