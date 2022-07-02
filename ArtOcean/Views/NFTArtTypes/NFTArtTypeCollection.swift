//
//  NFTArtTypeCollection.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

struct NFTArtType{
	var name:String
	var key:String
	var color:UIColor
	
	static var allType:[NFTArtType] = [
		.init(name: "Art", key: "artType", color: .appOrangeColor.withAlphaComponent(0.17)),
		.init(name: "Sports", key: "sportsType", color: .appRedColor.withAlphaComponent(0.17)),
		.init(name: "Music", key: "musicType", color: .appVioletColor.withAlphaComponent(0.17)),
		.init(name: "Photography", key: "Photography", color: .appDarkGrayColor.withAlphaComponent(0.17))
	]
}

class NFTArtTypeCollectionViewCell:ConfigurableCell{
	
	private var collection:NFTArtTypeCollectionView?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configureCell(with model: [NFTArtType]) {
		collection = NFTArtTypeCollectionView()
		collection!.configureCollection(model)
		contentView.addSubview(collection!)
		contentView.setContraintsToChild(collection!, edgeInsets: .zero)
		collection?.heightAnchor.constraint(equalToConstant: 60).isActive = true
	}
	
}

class NFTArtTypeCollectionView:UICollectionView{
    
    private var nftTypes:[NFTArtType] = []
    
    init(){
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: UIScreen.main.bounds.width * 0.25, height: 40)
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        super.init(frame: .zero, collectionViewLayout: layout)
        
        register(NFTTypeCollectionCell.self, forCellWithReuseIdentifier: NFTTypeCollectionCell.identifier)
	
        delegate = self
        dataSource = self
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
		heightAnchor.constraint(equalToConstant: layout.itemSize.height + 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	

	public func configureCollection(_ artTypes:[NFTArtType]){
		self.nftTypes = artTypes
		reloadData()
	}
    
	override var intrinsicContentSize: CGSize{
		.init(width: UIScreen.main.bounds.width, height: 50)
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
        
        let artType = self.nftTypes[indexPath.row]
        
		cell.updateTypeCell(img: artType.key, type: artType.name, color: artType.color)
        
        return cell
    }
    
}
