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
    
    private var source: CollectionDelegateAndDataSource? {
        get { return objc_getAssociatedObject(self, &Self.propertyKey) as? CollectionDelegateAndDataSource }
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
    
    func reload(with source:CollectionDelegateAndDataSource){
        self.source = source
        dataSource = source
        delegate = source
        
        reloadData()
    }
    
}
