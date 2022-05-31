//
//  NFTTypeCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit



class NFTArtCollection: UICollectionView {
    
    public var nfts:[NFTModel]? = nil
    public var collectionDelegate: NFTLiveBidCollectionDelegate? = nil
    
    
    public static let smallCard:CGSize = .init(width: 176, height: 154)
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
            layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
            layout.itemSize = .init(width: itemSize.width, height: itemSize.height)
        }else{
            layout.sectionInset = .init(top: 10, left: 0, bottom: 10, right: 0)
            layout.itemSize = .init(width: itemSize.width, height: itemSize.height)
        }
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
    
        
        if itemSize == NFTArtCollection.largeCard{
            self.cellId = NFTArtCollectionLiveBidViewCell.identifier
            self.register(NFTArtCollectionLiveBidViewCell.self, forCellWithReuseIdentifier: NFTArtCollectionLiveBidViewCell.identifier)
        }else{
            self.cellId = NFTArtCollectionViewCell.identifier
            self.register(NFTArtCollectionViewCell.self, forCellWithReuseIdentifier: NFTArtCollectionViewCell.identifier)
        }
        

        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
        self.setupLayout()
        if self.nfts == nil{
            self.fetchNFTsFromFile()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fetchNFTs(){
        AlchemyAPI.shared.getNFTs(address: "0x8742fa292AFfB6e5eA88168539217f2e132294f9") { [weak self] result in
            switch result{
            case .success(let nfts):
                let filterNFTS = nfts.compactMap({$0.metadata?.image?.contains("https") ?? false ? $0 : nil})
                self?.nfts = (filterNFTS.count > 10 ? Array(filterNFTS[0...9]) : filterNFTS)
                print("(DEBUG) Got Data Successffuly !")
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            case .failure(let err):
                print("(error) err : ",err.localizedDescription)
            }
        }
    }
    
    func fetchNFTsFromFile(){
        AlchemyAPI.shared.getNftsFromFile(fileName: "nft") { [weak self] result in
            switch result{
            case .success(let nfts):
                let filterNFTS = nfts.compactMap({$0.metadata?.image?.contains("https") ?? false ? $0 : nil})
                self?.nfts = (filterNFTS.count > 5 ? Array(filterNFTS[0...4]) : filterNFTS)
                print("(DEBUG) Got Data Successffuly !")
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            case .failure(let err):
                print("(error) err : ",err.localizedDescription)
            }
        }
    }
    
    func setupLayout(){
        self.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
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
extension NFTArtCollection:NFTLiveBidCellDelegate{
    func viewArt(art: NFTModel) {
        self.collectionDelegate?.viewNFT(art: art)
    }
}

