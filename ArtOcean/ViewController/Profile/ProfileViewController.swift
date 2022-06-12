//
//  ProfileViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class ProfileViewController: UIViewController {

    private let gradient:CAGradientLayer
    
    private let profileHeader:UILabel =  CustomLabel(text: "Profile", size: 22, weight: .bold, color: .white, numOfLines: 1, adjustFontSize: true,autoLayout: false)
    
    private let settingButton:UIView = {
        let button = CustomButton(frame: .init(origin: .zero, size: .init(width: 40, height: 40)),cornerRadius: 20, name: "settings", handler: nil,autolayout: true)
        return button
    }()
    
    private let userProfileView:UIImageView = CustomImageView(named: "userProfileImage", cornerRadius: 32)
    
    private let backgroundImage:UIImageView = CustomImageView(named: "userProfileDefaultbackground", cornerRadius: 0, maskedCorners: nil)
    
    private let name:UILabel = CustomLabel(text: "Krishna Venkat", size: 18, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: true)
    
    private let username:UILabel = CustomLabel(text: "@cryptoPython", size: 14, weight: .medium, color: .gray, numOfLines: 1, adjustFontSize: true)
    
    private lazy var userDetailsView:UIStackView = {
        let stack = UIView.StackBuilder(views: [self.name,self.username], ratios: [0.5,0.5], spacing: 4, axis: .vertical)
        stack.alignment = .center
        return stack
    }()
    
    private var assetsView:CustomSelectorCollectionView = {
        let collection = CustomSelectorCollectionView(sections: [NFTArtOfferSection,NFTArtSection], layoutForSections: [NFTArtSection.type!:.standardVerticalTwoByTwoGrid,NFTArtOfferSection.type!:.basicLayout])
        return collection
    }()
    
    private lazy var favoriteButton:UIView = {
        let button = CustomButton(frame: .init(origin: .zero, size: .init(width: 40, height: 40)),cornerRadius: 20, name: "favorites", handler: self.onTapFavorites, autolayout: true)
        let label = CustomLabel(text: "Favorites", size: 12, weight: .medium, color: .gray, numOfLines: 1, adjustFontSize: true, autoLayout: true)
        label.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [button,label])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var walletButton:UIView = {
        let button = CustomButton(frame: .init(origin: .zero, size: .init(width: 40, height: 40)),cornerRadius: 20, name: "wallet", handler: self.onTapWallet, autolayout: true)
        let label = CustomLabel(text: "Wallet", size: 12, weight: .medium, color: .gray, numOfLines: 1, adjustFontSize: true, autoLayout: true)
        label.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [button,label])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var draftButton:UIView = {
        let button = CustomButton(frame: .init(origin: .zero, size: .init(width: 40, height: 40)),cornerRadius: 20, name: "draft", handler: onTapDrafts, autolayout: true)
        let label = CustomLabel(text: "Draft", size: 12, weight: .medium, color: .gray, numOfLines: 1, adjustFontSize: true, autoLayout: true)
        label.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [button,label])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let profileButton:UIView = {
        let button = CustomButton(frame: .init(origin: .zero, size: .init(width: 40, height: 40)),cornerRadius: 20, name: "profile", handler: nil, autolayout: true)
        let label = CustomLabel(text: "Profile", size: 12, weight: .medium, color: .gray, numOfLines: 1, adjustFontSize: true, autoLayout: true)
        label.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [button,label])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var userActionsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [favoriteButton,walletButton,draftButton,profileButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
    
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var headerStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        
        profileHeader.setContentHuggingPriority(.init(rawValue: 249), for: .horizontal)
        profileHeader.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
        
        stack.addArrangedSubview(self.profileHeader)
        stack.addArrangedSubview(self.settingButton)
        return stack
    }()
    
    init(){
        self.gradient = CAGradientLayer()
        self.gradient.colors = [UIColor.white.withAlphaComponent(0.2).cgColor,UIColor.white.withAlphaComponent(1).cgColor]
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradient.frame = .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 170))
    }
    
    func setupViews(){
        
        self.settingButton.layer.cornerRadius = 20
        
        self.backgroundImage.layer.addSublayer(self.gradient)
        
        self.view.addSubview(self.backgroundImage)

        self.view.addSubview(self.headerStack)
        
        self.view.addSubview(self.userProfileView)
        
        self.view.addSubview(self.userActionsStack)
        
        self.view.addSubview(self.userDetailsView)
        
        self.assetsView.collectionDelegate = self
        
        self.view.addSubview(self.assetsView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupLayout(){
        self.backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.backgroundImage.widthAnchor.constraint(equalTo:self.view.widthAnchor).isActive = true
        self.backgroundImage.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        
        self.headerStack.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3).isActive = true
        self.headerStack.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 56).isActive = true
        self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: self.headerStack.trailingAnchor, multiplier: 3).isActive = true
        self.headerStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.userProfileView.topAnchor.constraint(equalToSystemSpacingBelow: self.headerStack.bottomAnchor, multiplier: 6).isActive = true
        self.userProfileView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.userProfileView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        self.userProfileView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
    
        self.userDetailsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.userDetailsView.topAnchor.constraint(equalToSystemSpacingBelow: self.userProfileView.bottomAnchor, multiplier: 2).isActive = true
        
        
        self.userActionsStack.leadingAnchor.constraint(equalTo: self.headerStack.leadingAnchor).isActive = true
        self.userActionsStack.trailingAnchor.constraint(equalTo: self.headerStack.trailingAnchor).isActive = true
        self.userActionsStack.topAnchor.constraint(equalToSystemSpacingBelow: self.userDetailsView.bottomAnchor, multiplier: 2).isActive = true
        
        
        self.assetsView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3).isActive = true
        self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: self.assetsView.trailingAnchor, multiplier: 3).isActive = true
        self.assetsView.topAnchor.constraint(equalToSystemSpacingBelow: self.userActionsStack.bottomAnchor, multiplier: 2).isActive = true
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
