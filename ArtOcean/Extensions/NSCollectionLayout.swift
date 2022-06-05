//
//  NSCollectionLayout.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 05/06/2022.
//

import Foundation
import UIKit

extension NSCollectionLayoutSection{
    
    static var basicLayout:NSCollectionLayoutSection = {
        let itemLayout:NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let groupLayout:NSCollectionLayoutGroup = .vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),subitems: [itemLayout])

        
        let layout:NSCollectionLayoutSection = .init(group: groupLayout)
        
        return layout
    }()
    
    static var standardVerticalStackLayout:NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), subitems: [itemSize])
        
        let layout = NSCollectionLayoutSection(group: group)
    
        return layout
    }()
    
    static var standardVerticalTwoByTwoGrid:NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        itemSize.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180)), subitems: [itemSize])
        group.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        let layout = NSCollectionLayoutSection(group: group)
    
        return layout
    }()
    
}
