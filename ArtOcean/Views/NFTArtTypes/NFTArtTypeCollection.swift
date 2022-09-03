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
		.init(name: "Art", key: "artType", color: .appOrangeColor),
		.init(name: "Sports", key: "sportsType", color: .appRedColor),
		.init(name: "Music", key: "musicType", color: .appVioletColor),
		.init(name: "Photography", key: "Photography", color: .appDarkGrayColor)
	]
}

extension NFTArtType {
	
	var collectionCell: CollectionCellProvider {
		let label: UILabel = .init()
		name.body3Medium().renderInto(target: label)
		let image = UIImage.loadingBackgroundImage.imageView(size: .squared(24), cornerRadius: 5)
		image.setWidthWithPriority(24)
		let stack: UIStackView = .HStack(views: [image, label].filterEmpty(), spacing: 8, aligmment: .center)
		let view = stack.background(bgColor: color, edgeInsets: .init(by: 8), cornerRadius: 8)
		stack.setHeightWithPriority(24)
		return CollectionColumn<CustomCollectionCell>(.init(innerView: view, edgeInsets: .zero))
	}
	
}

class NFTArtTypeCollectionView: UIView{
    
    private var nftTypes:[NFTArtType] = []
    
	private var collectionlayout: UICollectionViewFlowLayout {
		let layout =  UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		layout.minimumInteritemSpacing = 12
		layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
		return layout
	}
	
	private var collection: UICollectionView = {
		let collection: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
		collection.showsVerticalScrollIndicator = false
		collection.showsHorizontalScrollIndicator = false
		collection.backgroundColor = .clear
		return collection
	}()
	
	override init(frame: CGRect){
		super.init(frame: frame)
		backgroundColor = .clear
        addSubview(collection)
		setConstraintsToChild(collection, edgeInsets: .zero)
		collection.reload(with: buildCollectionDataSource())
    }
    
    required init?(coder: NSCoder) {
		super.init(coder: coder)
    }
	
	private func buildCollectionDataSource() -> CollectionDataSource {
		.init(columns: NFTArtType.allType.map(\.collectionCell), layout: collectionlayout, width: .totalWidth, height: 60)
	}
	
	override var intrinsicContentSize: CGSize{
		collection.compressedFittingSize
	}
}

