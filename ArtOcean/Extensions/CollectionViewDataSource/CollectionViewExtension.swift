//
//  CollectionViewExtension.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 06/07/2022.
//

import Foundation
import UIKit

extension UICollectionView{
    
    private static var propertyKey: UInt8 = 1
    
    private var source: CollectionDataSource? {
        get { return objc_getAssociatedObject(self, &Self.propertyKey) as? CollectionDataSource }
        set { objc_setAssociatedObject(self, &Self.propertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func dequeueCell<T:UICollectionViewCell>(for indexPath:IndexPath) -> T{
        let identifier = "\(T.self)"
        register(T.self, forCellWithReuseIdentifier: identifier)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else{
            return T()
        }
        return cell
    }
    
    func reload(with source:CollectionDataSource){
        self.source = source
        dataSource = source
        delegate = source
		collectionViewLayout = source.layout
		
		showsVerticalScrollIndicator = source.layout.scrollDirection != .vertical
		showsHorizontalScrollIndicator = source.layout.scrollDirection != .horizontal
		
		heightAnchor.constraint(equalToConstant: source.collectionHeight).isActive = true
		
        reloadData()
    }
    
}
