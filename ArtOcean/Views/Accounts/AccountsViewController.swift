//
//  AccountsViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 02/06/2022.
//

import Foundation
import UIKit

class AccountViewController:UIViewController{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = .white
        self.setupViews()
        self.configNavbar()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: -200)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
    }
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        return scrollView
    }()
    
    private lazy var headerBackdropView:AccountHeaderView = {
        let view =  AccountHeaderView {
            self.navigationController?.popViewController(animated: true)
        }
        return view
    }()

    func setupViews(){
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.headerBackdropView)
        self.scrollView.addSubview(self.profileImageView)
        self.scrollView.addSubview(self.headingView)
        self.scrollView.addSubview(self.descriptionView)
        self.scrollView.addSubview(self.metricsBar)
        self.scrollView.addSubview(self.selectorCollectionView)
    
    }
    
    func configNavbar(){
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = self.backButton
    }
    
    private lazy var backButton:UIBarButtonItem = {
        let backButton = CustomButton.backButton
        backButton.handler = {
            self.navigationController?.popViewController(animated: true)
        }
        
        let barButtonItem = UIBarButtonItem(customView: CustomButton.backButton)
        
        return barButtonItem
        
    }()
    
    private var profileImageView:CustomImageView = {
        let image = CustomImageView(named: "profileImageTwo", cornerRadius: 16, maskedCorners: nil)
        return image
    }()
    
    private lazy var username:CustomLabel = CustomLabel(text: "LionKing", size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1, adjustFontSize: false)
    
    private lazy var instagramButton:CustomImageView = {
        let imageView = CustomImageView(named: "instagram", cornerRadius: 0, maskedCorners: nil)
        imageView.contentMode = .scaleAspectFit
        let tapRecog = UITapGestureRecognizer()
        tapRecog.addTarget(self, action: #selector(self.TappedInstagram))
        imageView.addGestureRecognizer(tapRecog)
        return imageView
    }()
    
    private lazy var twitterButton:CustomImageView = {
        let imageView = CustomImageView(named: "twitter", cornerRadius: 0, maskedCorners: nil)
        imageView.contentMode = .scaleAspectFit
        let tapRecog = UITapGestureRecognizer()
        tapRecog.addTarget(self, action: #selector(self.TappedTwitter))
        imageView.addGestureRecognizer(tapRecog)
        return imageView
    }()
    
    private lazy var twitchButton:CustomImageView = {
        let imageView = CustomImageView(named: "twitch", cornerRadius: 0, maskedCorners: nil)
        imageView.contentMode = .scaleAspectFit
        let tapRecog = UITapGestureRecognizer()
        tapRecog.addTarget(self, action: #selector(self.TappedTwitch))
        imageView.addGestureRecognizer(tapRecog)
        return imageView
    }()
    
    
    private lazy var metricsBar:UIView = {
        let metrics = AccoutnMetrics(metrics: ["Items":"1.73K","Owners":"1.24K","Floor price":"0.24","Traded":"325"])
        return metrics
    }()
    
    @objc func TappedTwitch(){
        print("(DEBUG) Clicked on twitch")
    }
    
    @objc func TappedTwitter(){
        print("(DEBUG) Clicked on twitter")
    }
    
    @objc func TappedInstagram(){
        print("(DEBUG) Clicked on instagram")
    }
    
    private lazy var descriptionView:CustomLabel = CustomLabel(text: "I have a love for abstraction and felt so represented nomadic frontierism like the idea of the space with that loose idea in mind my Invaders set voyage on their spaceship.", size: 14, weight: .regular, color: .appBlackColor, numOfLines: 4, adjustFontSize: true)
    
    private lazy var headingView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let stackSocialView:UIStackView = UIView.StackBuilder(views: [instagramButton,twitchButton,twitterButton], ratios: [0.33,0.34,0.33], spacing: 10, axis: .horizontal)
        
        view.addSubview(username)
        view.addSubview(stackSocialView)
        
        NSLayoutConstraint.activate([
            stackSocialView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackSocialView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackSocialView.widthAnchor.constraint(equalToConstant: 100),
            stackSocialView.heightAnchor.constraint(equalToConstant: 12),
            username.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            username.trailingAnchor.constraint(equalTo: stackSocialView.leadingAnchor),
            username.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
        
        return view
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    private lazy var selectorCollectionView:CustomSelectorCollectionView = {
        let collection = CustomSelectorCollectionView(sections: [NFTArtSection,NFTArtOfferSection], layoutForSections: [NFTArtSection.type!:.standardVerticalTwoByTwoGrid,NFTArtOfferSection.type!:.standardVerticalStackLayout])
        collection.collectionDelegate = self
        collection.customCollectionView.delegate = self
        collection.customCollectionView.isScrollEnabled = false
        return collection
    }()
    func setupLayout(){
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.headerBackdropView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.headerBackdropView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.headerBackdropView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.headerBackdropView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        self.profileImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leadingAnchor, multiplier: 3).isActive = true
        self.profileImageView.centerYAnchor.constraint(equalTo: self.headerBackdropView.bottomAnchor).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        
        self.headingView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leadingAnchor, multiplier: 3).isActive = true
        self.headingView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: -24).isActive = true
        self.headingView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.headingView.topAnchor.constraint(equalToSystemSpacingBelow: self.profileImageView.bottomAnchor, multiplier: 2).isActive = true
        
        
        self.descriptionView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leadingAnchor, multiplier: 3).isActive = true
        self.descriptionView.topAnchor.constraint(equalToSystemSpacingBelow: self.headingView.bottomAnchor, multiplier: 1).isActive = true
        self.descriptionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        
        
        self.metricsBar.leadingAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leadingAnchor, multiplier: 3).isActive = true
        self.metricsBar.topAnchor.constraint(equalToSystemSpacingBelow: self.descriptionView.bottomAnchor, multiplier: 3).isActive = true
        self.metricsBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -24).isActive = true
        self.metricsBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.selectorCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: self.metricsBar.bottomAnchor, multiplier: 3).isActive = true
        self.selectorCollectionView.leadingAnchor.constraint(equalTo: self.metricsBar.leadingAnchor).isActive = true
        self.selectorCollectionView.trailingAnchor.constraint(equalTo: self.descriptionView.trailingAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalToSystemSpacingBelow: self.selectorCollectionView.bottomAnchor, multiplier: 3).isActive = true
        
        
    }
}

//MARK: - AccountViewController

extension AccountViewController:UIScrollViewDelegate,UICollectionViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.selectorCollectionView.customCollectionView{
            if scrollView.contentOffset.y < 0{
                self.scrollView.setContentOffset(.init(x: 0, y: self.scrollView.contentOffset.y + scrollView.contentOffset.y), animated: false)
                scrollView.isScrollEnabled = false
                self.scrollView.isScrollEnabled = true
            }
        }else{
            self.headerBackdropView.viewAnimationWithScroll(scrollView)
            let selectorPosition = self.selectorCollectionView.convert(scrollView.frame.origin, to: nil)
            if selectorPosition.y <= self.view.safeAreaInsets.top{
                scrollView.setContentOffset(.init(x: scrollView.contentOffset.x, y: self.selectorCollectionView.frame.origin.y - self.view.safeAreaInsets.top), animated: false)
                self.scrollView.isScrollEnabled = false
                self.selectorCollectionView.customCollectionView.isScrollEnabled = true
            }
        }
        
        
    }
}


//MARK: - AccountViewController

extension AccountViewController:CustomComplexCollectionViewDelegate{
    
    func registerCellToCollection(_ collection: UICollectionView) {
        collection.register(NFTArtCollectionViewCell.self, forCellWithReuseIdentifier: NFTArtCollectionViewCell.identifier)
        collection.register(StatisticActivityCollectionViewCell.self, forCellWithReuseIdentifier: StatisticActivityCollectionViewCell.identifier)
    }
    
    
    func cellForCollection(_ collection:UICollectionView,_ section: SectionType, _ indexPath: IndexPath, _ item: Item) -> ConfirgurableCell? {
        switch section{
            case "ART":
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: NFTArtCollectionViewCell.identifier, for: indexPath) as? NFTArtCollectionViewCell else {
                    return nil
                }
                cell.configure(item)
                cell.delegate = self
                return cell
            case "OFFER":
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: StatisticActivityCollectionViewCell.identifier, for: indexPath) as? StatisticActivityCollectionViewCell else {
                    return nil
                }
                cell.configure(item)
                cell.buttonDelegate = self
                return cell
            default:
                print("(DEBUG) No CellFor : ",section)
                return nil
        }
    }
    
}


//MARK: - NFTArtDelegate
extension AccountViewController:NFTArtCellDelegate{
    
    func viewArt(art: NFTModel) {
        self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: art), animated: true)
    }
    
}


//MARK: - CustomButtonDelegate
extension AccountViewController:CustomButtonDelegate{
    
    func handleTap(_ data: Any) {
        if let art = data as? NFTArtOffer,let nft = art.nft{
            self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: nft), animated: true)
        }
    }
}
