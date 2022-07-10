//
//  NFTTypeCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

struct NFTArtCollectionModel{
	var nfts:[NFTModel]
	var size:CGSize
	var action:((NFTModel) -> Void)?
}

class NFTArtCollectionCell:ConfigurableCell{
	
	private var collectionView:NFTArtCollection?
	private var model:NFTArtCollectionModel?
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
//		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupUI(){
		guard let safeCollectionView = collectionView else { return }
		
	}
	
	func configureCell(with model: NFTArtCollectionModel) {
		self.model = model
		print("(DEBUG) model.size : ",model.size)
		collectionView = .init(orientation: .horizontal, itemSize:model.size)
		collectionView?.updateCollection(model.nfts)
		collectionView?.collectionDelegate = self
		collectionView?.backgroundColor = .white
		contentView.addSubview(collectionView!)
		contentView.setContraintsToChild(collectionView!, edgeInsets: .zero)
	}
	
	
}
//MARK: - CollectionDelegate
extension NFTArtCollectionCell:NFTLiveBidCollectionDelegate{
	func viewAll(allArt: [NFTModel]) {}
	
	func viewNFT(art: NFTModel) {
		model?.action?(art)
	}
}


class NFTArtCollection: UICollectionView {
    
    public var nfts:[NFTModel]?
    public var collectionDelegate: NFTLiveBidCollectionDelegate?
    
    
    public static let smallCard:CGSize = .init(width: 154, height: 176)
    public static let largeCard:CGSize = .init(width: 225, height: 245)
    private var cellId:String = ""
    
    init(
        nfts:[NFTModel]? = nil,
        orientation:UICollectionView.ScrollDirection = .horizontal,
        itemSize:CGSize = NFTArtCollection.largeCard
    ){
        
        //collectionLayout
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = orientation
        
        if orientation == .horizontal{
            layout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
            layout.itemSize = .init(width: itemSize.width, height: itemSize.height)
        }else{
            layout.sectionInset = .init(top: 8, left: 0, bottom: 8, right: 0)
            layout.itemSize = .init(width: itemSize.width, height: itemSize.height)
        }
        
        super.init(frame: .zero, collectionViewLayout: layout)
        contentInsetAdjustmentBehavior = .never
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
    
        
        if itemSize == NFTArtCollection.smallCard{
            cellId = NFTArtCollectionViewCell.identifier
            register(NFTArtCollectionViewCell.self, forCellWithReuseIdentifier: NFTArtCollectionViewCell.identifier)
        }else{
            cellId = NFTArtCollectionLiveBidViewCell.identifier
            register(NFTArtCollectionLiveBidViewCell.self, forCellWithReuseIdentifier: NFTArtCollectionLiveBidViewCell.identifier)
        }
		
        delegate = self
        dataSource = self
		heightAnchor.constraint(equalToConstant: layout.itemSize.height + 20).isActive = true
    }
	
	convenience init(orientation:UICollectionView.ScrollDirection = .horizontal,itemSize:CGSize = NFTArtCollection.largeCard){
		self.init(nfts: nil, orientation: .horizontal, itemSize: itemSize)
	}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
	public func updateCollection(_ nfts:[NFTModel]){
		self.nfts = nfts
		reloadData()
	}

}

// MARK: - UICollectionDelegates
extension NFTArtCollection:UICollectionViewDelegate,UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nfts?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? NFTArtCollectionLiveBidViewCell{
            cell.delegate = self
            if let safeNFTs = self.nfts, indexPath.row < safeNFTs.count{
                cell.updateUIWithNFT(safeNFTs[indexPath.row],idx: indexPath.row)
            }
            
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? NFTArtCollectionViewCell {
            cell.delegate = self
            if let safeNFTs = self.nfts, indexPath.row < safeNFTs.count{
                cell.updateUIWithNFT(safeNFTs[indexPath.row], idx: indexPath.row)
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
}

// MARK: - NFTLiveBidCellDelegate
extension NFTArtCollection:NFTArtCellDelegate{
    func viewArt(art: NFTModel) {
        self.collectionDelegate?.viewNFT(art: art)
    }
}

