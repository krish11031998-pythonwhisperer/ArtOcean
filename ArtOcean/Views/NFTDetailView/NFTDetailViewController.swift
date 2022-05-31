//
//  NFTDetailViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 29/05/2022.
//

import Foundation
import UIKit

class NFTDetailArtViewController:UIViewController{
    
    private var nftArt:NFTModel?
    private var placeBidModalLeadingAnchor:NSLayoutConstraint? = nil
    private var leadingOffScreen:CGFloat = 1000
    private let leadingOnScreen:CGFloat = 24
    private var imageScale:CGFloat = 1
    private var imageViewHeightAnchor:NSLayoutConstraint? = nil
    private var imageViewWidthAnchor:NSLayoutConstraint? = nil
    
    init(nftArt:NFTModel) {
        self.nftArt = nftArt
        self.titleView = CustomLabel(text: nftArt.Title, size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1, adjustFontSize: true)
        self.descriptionView = CustomLabel(text: nftArt.Description, size: 14, weight: .medium, color: .appGrayColor, numOfLines: 3, adjustFontSize: false)
        super.init(nibName: nil, bundle: nil)
        self.heroHeaderView = NFTHeroHeaderView(nft: nftArt, handler: {
            self.navigationController?.popViewController(animated: true)
        })
        self.setupView()
        self.setupLayout()
        self.setupStatusBar()
    }
    
    //MARK: -  NavigationItem
    private lazy var backBarButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        
        let backButton = CustomButton(systemName: "chevron.left", handler: {
            self.navigationController?.popViewController(animated: true)
        }, autolayout: true)
        backButton.handler = {
            self.navigationController?.popViewController(animated: true)
        }
        
        barButton.customView = backButton
        
        return barButton
    }()
    
    //MARK: - Views
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var placeBidButton:CustomLabelButton = {
        let button = CustomLabelButton(title: "Place a Bid", color: .white, backgroundColor: .appBlueColor)
        button.delegate = self
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var heroHeaderView:UIView = .clearView()
    
    private lazy var artInteractiveInfoView:NFTArtInteractiveInfoView = .init(nft: self.nftArt ?? .init(contract: nil, id: nil, balance: nil, title: nil, description: nil, metadata: nil))
    
    private lazy var imageView:CustomImageView = CustomImageView(cornerRadius: 16)
    
    private let titleView:CustomLabel
    
    private let descriptionView:CustomLabel
    
    private lazy var creatorLabel:UILabel = self.view.labelBuilder(text: "Pablo", size: 14, weight: .bold, color: .appBlueColor, numOfLines: 1,adjustFontSize: false)
    
    private lazy var timeEndsLabel:UILabel = self.view.labelBuilder(text: "08h 34m 59s", size: 14, weight: .bold, color: .black, numOfLines: 1,adjustFontSize: false)
    
    private lazy var creatorView:UIStackView = {
        return self.stackBuilder(header: "Created by",alignment: .left, label: self.creatorLabel)
    }()
    
    private let creatorImage:CustomImageView = {
        let image = CustomImageView(cornerRadius: 16)
        image.backgroundColor = .black
        return image
    }()
    
    private lazy var artInfoSnippet:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(creatorView)
        stack.addArrangedSubview(self.creatorImage)
        
        self.creatorImage.frame.size.height = 32
        
        NSLayoutConstraint.activate([
            creatorView.widthAnchor.constraint(equalTo: stack.widthAnchor,multiplier: 1, constant: -40),
            creatorImage.widthAnchor.constraint(equalToConstant:32),
        ])
        
        return stack
    }()
    
    
    private lazy var offerView:Container = {
        let container = Container(header: "Offers", rightButtonTitle: "Last 7 Days", innerView: NFTOffersTableView(), innerViewSize: .init(width: UIScreen.main.bounds.width - 50, height: 300),paddingToHeaderView: false) {
            print("(DEBUG) Clicked on last 7 days Button!")
        }
        return container
    }()
    
    private lazy var placeBidModal:NFTBiddingModal = {
        let view = NFTBiddingModal {
            self.closeModal()
        }
        return view
    }()
    
    private let biddingController:NFTBiddingController = NFTBiddingController()

    
    //MARK: - View Setups
    
    func setupView(){
        
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.heroHeaderView)
        
        self.setupImageView()
        
        self.scrollView.addSubview(self.artInteractiveInfoView)
        
        self.scrollView.addSubview(self.titleView)
        
        self.scrollView.addSubview(self.descriptionView)
    
        self.scrollView.addSubview(self.artInfoSnippet)
        
        self.scrollView.addSubview(self.biddingController)
        
        self.scrollView.addSubview(self.offerView)
        
        self.scrollView.addSubview(self.placeBidButton)

        self.view.addSubview(self.placeBidModal)
    }
    
    func setupImageView(){
        self.scrollView.addSubview(self.imageView)
        guard let safeImg = self.nftArt?.metadata?.image else{return}
        ImageDownloader.shared.fetchImage(urlStr: safeImg) { [weak self] result in
            switch result{
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    if let safeHeroHeaderView = self?.heroHeaderView as? NFTHeroHeaderView{
                        safeHeroHeaderView.updatebackgroundImage(image)
                    }
                }
            case .failure(let err):
                print("(Error) Error : ",err.localizedDescription)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayout(){
        
        self.heroHeaderView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.heroHeaderView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.heroHeaderView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.heroHeaderView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        //ImageView
        self.imageView.topAnchor.constraint(equalTo: self.heroHeaderView.bottomAnchor, constant: -50).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.imageViewWidthAnchor = self.imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 50)
        self.imageViewWidthAnchor?.isActive = true
        self.imageViewHeightAnchor = self.imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.35)
        self.imageViewHeightAnchor?.isActive = true
        
        //ArtInteractiveInfoView
        self.artInteractiveInfoView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 18).isActive = true
        self.artInteractiveInfoView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 25).isActive = true
        self.artInteractiveInfoView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.artInteractiveInfoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //Title
        self.titleView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 25).isActive = true
        self.titleView.topAnchor.constraint(equalTo: self.artInteractiveInfoView.bottomAnchor, constant: 17).isActive = true
        self.titleView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.titleView.heightAnchor.constraint(equalToConstant: 25).isActive = true

        self.descriptionView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 25).isActive = true
        self.descriptionView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8).isActive = true
        self.descriptionView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.descriptionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        //ArtInfoSnippet
        self.artInfoSnippet.leadingAnchor.constraint(equalTo: self.artInteractiveInfoView.leadingAnchor).isActive = true
        self.artInfoSnippet.trailingAnchor.constraint(equalTo: self.artInteractiveInfoView.trailingAnchor).isActive = true
        self.artInfoSnippet.topAnchor.constraint(equalTo: self.descriptionView.bottomAnchor, constant: 12).isActive = true
        self.artInfoSnippet.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.artInfoSnippet.widthAnchor.constraint(equalTo: self.artInteractiveInfoView.widthAnchor).isActive = true
        
        //BiddingController
        self.biddingController.leadingAnchor.constraint(equalTo: self.artInfoSnippet.leadingAnchor).isActive = true
        self.biddingController.trailingAnchor.constraint(equalTo: self.artInfoSnippet.trailingAnchor).isActive = true
        self.biddingController.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.biddingController.topAnchor.constraint(equalTo: self.artInfoSnippet.bottomAnchor, constant: 25).isActive = true
        
        
        //OffersView
        self.offerView.topAnchor.constraint(equalTo: self.biddingController.bottomAnchor, constant: 25).isActive = true
        self.offerView.leadingAnchor.constraint(equalTo: self.biddingController.leadingAnchor).isActive = true
        
        //PlaceBidButton
        self.placeBidButton.leadingAnchor.constraint(equalTo: self.artInfoSnippet.leadingAnchor).isActive = true
        self.placeBidButton.topAnchor.constraint(equalTo: self.offerView.bottomAnchor, constant: 20).isActive = true
        self.placeBidButton.trailingAnchor.constraint(equalTo: self.artInfoSnippet.trailingAnchor).isActive = true
        self.placeBidButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //PlaceBidModal
        self.placeBidModal.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.placeBidModal.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 48).isActive = true
        self.placeBidModal.heightAnchor.constraint(equalToConstant: 300).isActive = true

        self.placeBidModalLeadingAnchor = self.placeBidModal.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.leadingOffScreen)
        self.placeBidModalLeadingAnchor?.isActive = true

    }
}

//MARK: - ViewBuilder Helpers

extension NFTDetailArtViewController{
    func stackBuilder(header:String,alignment:NSTextAlignment,label:UILabel) -> UIStackView{
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        
        let headerLabel:UILabel = self.view.labelBuilder(text: header, size: 12, weight: .regular, color: .black, numOfLines: 1)
        headerLabel.textAlignment = alignment
        label.textAlignment = alignment
        stack.addArrangedSubview(headerLabel)
        stack.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            headerLabel.heightAnchor.constraint(equalTo: stack.heightAnchor,multiplier: 0.5, constant: -4),
            label.heightAnchor.constraint(equalTo: stack.heightAnchor,multiplier: 0.5, constant: -4)
        ])
        
        return stack
    }
    
    func closeDetailView(){
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - CustomLabelButtonDelegate

extension NFTDetailArtViewController:CustomButtonDelegate{
    func handleTap() {
        let animation = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.placeBidModalLeadingAnchor?.constant = self.leadingOnScreen
            self.scrollView.isScrollEnabled = false
            self.scrollView.layer.opacity = 0.5
            self.view.layoutIfNeeded()
        }
        animation.startAnimation()
    }
    
    func closeModal(){
        let animation = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.placeBidModalLeadingAnchor?.constant = -self.leadingOffScreen
            self.leadingOffScreen = -self.leadingOffScreen
            self.scrollView.isScrollEnabled = true
            self.scrollView.layer.opacity = 1
            self.view.layoutIfNeeded()
        }
        animation.startAnimation()
    }
}


//MARK: - ScrollViewDelegate
extension NFTDetailArtViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = imageView.convert(scrollView.frame.origin, to: nil).y * imageScale
        let maxPoint = self.imageView.frame.minY
        let minPoint = -self.imageView.frame.height * 0.25
        let scaleFactor =  (point - minPoint)/(maxPoint - minPoint)
        self.imageScale = scaleFactor > 1 ? 1 : scaleFactor < 0.5 ? 0.5 : scaleFactor
        
        UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) {
            self.imageViewHeightAnchor?.constant = self.imageScale * (UIScreen.main.bounds.height * 0.35)
            self.imageViewWidthAnchor?.constant = self.imageScale * (UIScreen.main.bounds.width - 50)
            self.imageView.layoutIfNeeded()
            self.scrollView.layoutIfNeeded()
        }.startAnimation()
        
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: max(scrollView.contentOffset.y - 100,0))
        
        
    }
}
