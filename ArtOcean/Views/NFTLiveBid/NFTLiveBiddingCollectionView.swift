//
//  NFTTypeCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class NFTLiveBiddingCollectionView: UIView {
    
    private var nfts:[NFTModel]? = nil
    public var seeAllArt:(() -> Void)?
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.register(NFTLiveBidCollectionViewCell.self, forCellWithReuseIdentifier: NFTLiveBidCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    

    
    init(orientation:UICollectionView.ScrollDirection = .horizontal,itemSize:CGSize = .init(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.3)){
        super.init(frame: .zero)
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = orientation
            layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
            if orientation == .horizontal{
                layout.itemSize = .init(width: itemSize.width, height: itemSize.height - 20)
            }else{
                layout.itemSize = .init(width: itemSize.width - 20, height: itemSize.height)
            }
            
            self.collectionView.collectionViewLayout = layout
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(self.collectionView)
        
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
                    self?.collectionView.reloadData()
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
                    self?.collectionView.reloadData()
                }
            case .failure(let err):
                print("(error) err : ",err.localizedDescription)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("(DEBUG) bounds : ",self.bounds)
        self.setupLayout()
    }
    
    func setupLayout(){
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.collectionView.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
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
