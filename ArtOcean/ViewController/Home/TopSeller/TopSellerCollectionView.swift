//
//  TopSellerCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 31/05/2022.
//

import Foundation
import UIKit

class TopSellerCollectionView:UICollectionView{
    
    var sellers:[(name:String,imgName:String,percent:Float)] = Array(repeating: (name:"Shapire Cole",imgName:"",percent:0), count: 10)
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 125, height: 50)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 10)
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.register(TopSellerCollectionViewCell.self, forCellWithReuseIdentifier: TopSellerCollectionViewCell.identifier)
        self.dataSource = self
        self.delegate = self
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


//MARK: - TopSellerCollection
extension TopSellerCollectionView:UICollectionViewDelegate,UICollectionViewDataSource{
    override var numberOfSections: Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.sellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopSellerCollectionViewCell.identifier, for: indexPath) as? TopSellerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let seller = self.sellers[indexPath.row]
//        cell.backgroundColor = .blue
        cell.updateUI(seller)
        
        return cell
    }
}
