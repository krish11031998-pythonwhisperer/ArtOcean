//
//  TopSellerCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 31/05/2022.
//

import Foundation
import UIKit


struct SellerData{
	var name:String
	var image:String
	var percent:Float
	
	static var test:SellerData = .init(name: "Shapire Cole", image: "", percent: Float.random(in: 1...15))
}


class TopSellerCollectionViewTableCell:ConfigurableCell{
	private var sellerCollectionView:TopSellerCollectionView?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func configureCell(with model: [SellerData]) {
		sellerCollectionView = TopSellerCollectionView()
		contentView.addSubview(sellerCollectionView!)
		contentView.setContraintsToChild(sellerCollectionView!, edgeInsets: .zero)
		sellerCollectionView?.updateCollection(model)
	}
}

class TopSellerCollectionView:UICollectionView{
    
	var sellers:[SellerData] = Array(repeating: .test, count: 10)
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 125, height: 42)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
		layout.minimumLineSpacing = 12
        layout.sectionInset = .init(top: 10, left: 15, bottom: 10, right: 15)
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(TopSellerCollectionViewCell.self, forCellWithReuseIdentifier: TopSellerCollectionViewCell.identifier)
        dataSource = self
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
		heightAnchor.constraint(equalToConstant: layout.itemSize.height * 2 + 32).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	public func updateCollection(_ sellers:[SellerData]){
		self.sellers = sellers
		reloadData()
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
        cell.updateUI(seller)
        
        return cell
    }
}
