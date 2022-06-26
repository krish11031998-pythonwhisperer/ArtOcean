//
//  NFTArtTypeCollection.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

class NFTArtTypeCollectionView:UICollectionView{
    
    private var nftTypes:[(String,String,UIColor)] = [
        ("Art","artType",.appOrangeColor.withAlphaComponent(0.17)),
        ("Sports","sportsType",.appRedColor.withAlphaComponent(0.17)),
        ("Music","musicType",.appVioletColor.withAlphaComponent(0.17)),
        ("Photography","photoType",.appDarkGrayColor.withAlphaComponent(0.17))
    ]
    
    init(){
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: UIScreen.main.bounds.width * 0.25, height: 40)
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(NFTTypeCollectionCell.self, forCellWithReuseIdentifier: NFTTypeCollectionCell.identifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.delegate = self
        self.dataSource = self
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override var intrinsicContentSize: CGSize{
		return .init(width: UIScreen.main.bounds.width, height: 50)
	}
    
}

//MARK: - NFTArtTypeCollectionView UICollectionViewDelegate

extension NFTArtTypeCollectionView:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nftTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTTypeCollectionCell.identifier, for: indexPath) as? NFTTypeCollectionCell else{
            return UICollectionViewCell()
        }
        
        let (typeName,cellName,color) = self.nftTypes[indexPath.row]
        
        cell.updateTypeCell(img: cellName, type: typeName, color: color)
        
        return cell
    }
    
}
