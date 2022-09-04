//
//  UICollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 03/06/2022.
//

import Foundation

public protocol ReusableConfigurableCell{
    static var reusableIdentifier:String { get }
    func configureCell(with data:Any)
}
