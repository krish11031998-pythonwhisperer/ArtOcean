//
//  ProfileViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class ProfileViewController: UIViewController {
	
	private lazy var profileHeaderView: UIView = {
		let headerView = ProfileHeaderView(frame: .init(origin: .zero, size: .init(width: .totalWidth ,height: 375)))
		headerView.delegate = self
		return headerView
	}()
    
    private var assetsView:CustomSelectorCollectionView = {
        let collection = CustomSelectorCollectionView(sections: [NFTArtOfferSection,NFTArtSection], layoutForSections: [NFTArtSection.type!:.standardVerticalTwoByTwoGrid,NFTArtOfferSection.type!:.basicLayout])
		return collection
    }()

    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.hideNavigationBarLine()
        self.setupStatusBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        self.setupViews()
        self.setupLayout()
    }
    
    func setupViews(){
        
		view.addSubview(profileHeaderView)
        
        assetsView.collectionDelegate = self
        
        view.addSubview(self.assetsView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupLayout(){
		view.setWidthForChildWithPadding(assetsView,paddingFactor: 3)
		assetsView.topAnchor.constraint(equalToSystemSpacingBelow: profileHeaderView.bottomAnchor, multiplier: 2).isActive = true
        self.view.bottomAnchor.constraint(equalToSystemSpacingBelow: self.assetsView.bottomAnchor, multiplier: 4).isActive = true
    }
    

}

//MARK: - CustomCollectionSectionDelegate
extension ProfileViewController:CustomComplexCollectionViewDelegate{
    func registerCellToCollection(_ collection: UICollectionView) {
        collection.register(NFTArtCollectionViewCell.self, forCellWithReuseIdentifier: NFTArtCollectionViewCell.identifier)
        collection.register(StatisticActivityCollectionViewCell.self, forCellWithReuseIdentifier: StatisticActivityCollectionViewCell.identifier)
    }
    
    func cellForCollection(_ collection: UICollectionView, _ section: SectionType, _ indexPath: IndexPath, _ item: Item) -> ConfirgurableCell? {
        switch section{
        case NFTArtSection.type!:
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: NFTArtCollectionViewCell.identifier, for: indexPath) as? NFTArtCollectionViewCell else {
                return nil
            }
            
            cell.configure(item)
            cell.delegate = self
            return cell
        case NFTArtOfferSection.type!:
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: StatisticActivityCollectionViewCell.identifier, for: indexPath) as? StatisticActivityCollectionViewCell else{
                return nil
            }
            
            cell.configure(item)
            cell.buttonDelegate = self
            return cell
        default:
            return nil
        }
    }
}

//MARK: - NFTArtDelegate
extension ProfileViewController:NFTArtCellDelegate{
    
    func viewArt(art: NFTModel) {
        self.setupStatusBar()
        self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: art), animated: true)
    }
    
}


//MARK: - CustomButtonDelegate
extension ProfileViewController:CustomButtonDelegate{
    
    func handleTap(_ data: Any) {
        if let art = data as? NFTArtOffer,let nft = art.nft{
            self.setupStatusBar()
            self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: nft), animated: true)
        }
    }
}

//MARK: - ProfileHeaderDelegate
extension ProfileViewController: ProfileHeaderEventDelegate {
	func clickedOnProfileButton(_ identifier: String) {
		switch identifier {
		case "Wallet":
			onTapWallet()
		case "Favorites":
			onTapFavorites()
		case "Draft":
			onTapDrafts()
		default:
			print("(DEBUG) No Action for this button has been assigned!")
		}
	}
}

//MARK: - ButtonHandler
extension ProfileViewController{
    
    func onTapFavorites(){
        self.navigationController?.pushViewController(ProfileAssetCollectionViewController(art: NFTModel.testsArtData ?? [],name: "Favorite"), animated: true)
    }
    
    func onTapDrafts(){
        self.navigationController?.pushViewController(ProfileAssetCollectionViewController(art: NFTModel.testsArtData ?? [], name: "Draft"), animated: true)
    }
    
    func onTapWallet(){
        self.navigationController?.pushViewController(WalletDetailView(), animated: true)
    }
}
