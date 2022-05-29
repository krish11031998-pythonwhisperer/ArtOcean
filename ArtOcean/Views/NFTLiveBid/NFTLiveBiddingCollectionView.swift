//
//  NFTTypeCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class NFTLiveBiddingCollectionView: UICollectionView {
    
    private var nfts:[NFTModel]? = nil
    public var seeAllArt:(() -> Void)?
    
    init(orientation:UICollectionView.ScrollDirection = .horizontal,itemSize:CGSize = .init(width: UIScreen.main.bounds.width * 0.6, height: 245)){
        
        //collectionLayout
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = orientation
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        if orientation == .horizontal{
            layout.itemSize = .init(width: itemSize.width, height: itemSize.height - 20)
        }else{
            layout.itemSize = .init(width: itemSize.width - 20, height: itemSize.height)
        }
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        
        self.register(NFTLiveBidCollectionViewCell.self, forCellWithReuseIdentifier: NFTLiveBidCollectionViewCell.identifier)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
        self.setupLayout()
        self.fetchNFTsFromFile()
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

extension NFTLiveBiddingCollectionView:UICollectionViewDelegate,UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nfts?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTLiveBidCollectionViewCell.identifier, for: indexPath) as? NFTLiveBidCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        if let safeNFTs = self.nfts, indexPath.row < safeNFTs.count{
            cell.updateUIWithNFT(safeNFTs[indexPath.row],idx: indexPath.row)
        }
        
        return cell
    }
    
}
