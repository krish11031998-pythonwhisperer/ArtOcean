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
    
	private var assetsView:CustomSelectorDynamicCollectionView = {
		.init(sections: [NFTArtOfferSection,NFTArtSection])
	}()
	
	private lazy var backdropImage: UIImageView = {
		let imageView = UIImageView(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 200)))
		imageView.updateImageView(url: "https://gutterart.blob.core.windows.net/metadata/image/3.jpeg")
		imageView.blurGradientBackDrop(size: .init(width: UIScreen.main.bounds.width, height: 200))
		return imageView
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
		assetsView.delegate = self
    }
    
    func setupViews(){
		view.addSubview(backdropImage)
		view.setWidthForChildWithPadding(backdropImage, paddingFactor: .zero)
		backdropImage.setHeightWithPriority(200)
		
		let stack: UIStackView = .init(arrangedSubviews: [profileHeaderView, assetsView])
		stack.spacing = 10
		stack.axis = .vertical
		stack.alignment = .center
		stack.setWidthForChildWithPadding(profileHeaderView, paddingFactor: .zero)
		stack.setWidthForChildWithPadding(assetsView, paddingFactor: 2)
		view.addSubview(stack)
		view.setSafeAreaConstraintsToChild(stack, edgeInsets: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

//MARK: - CustomSelectorDynamicCollection Delegate

extension ProfileViewController: CustomSelectorDynamicCollectionDelegate {
	
	func collectionSection(_ section: Section) -> CollectionSection? {
		guard let validItems = section.items else { return nil }
		if section == NFTArtSection {
			return .init(cells: validItems.compactMap(\.nftArtData?.collectionCell))
		} else if section == NFTArtOfferSection {
			return .init(cells: validItems.compactMap(\.nftOffer?.collectionCell))
		} else {
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
		case "Profile":
			onTapProfile()
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
	
	func onTapProfile() {
		self.navigationController?.pushViewController(SettingViewController(), animated: true)
	}
}
