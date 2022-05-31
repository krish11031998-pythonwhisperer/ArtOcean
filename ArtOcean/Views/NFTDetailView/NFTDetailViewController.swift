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
    
    init(nftArt:NFTModel) {
        self.nftArt = nftArt
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
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
    
    private lazy var backgroundImageView:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 0,gradientColors: [UIColor.white.withAlphaComponent(0.2),UIColor.white.withAlphaComponent(1)])
        return imageView
    }()
    
    private lazy var heroHeaderView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.backgroundImageView)
        
        let leftButton = CustomButton(systemName: "chevron.left", handler: {
            self.navigationController?.popViewController(animated: true)
        }, autolayout: true)
        
        let titleView = self.view.labelBuilder(text: self.nftArt?.title ?? "XXXXX", size: 14, weight: .black, color: .appWhiteBackgroundColor, numOfLines: 1)
        
        
        view.addSubview(leftButton)
        view.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            self.backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            self.backgroundImageView.widthAnchor.constraint(equalTo:view.widthAnchor),
            self.backgroundImageView.heightAnchor.constraint(equalTo:view.heightAnchor),            leftButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            leftButton.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: leftButton.topAnchor),
            titleView.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor)
        ])
        
        return view
    }()
    
    private lazy var imageView:CustomImageView = CustomImageView(cornerRadius: 16)
    
    private lazy var titleView:UILabel = self.view.labelBuilder(text: "XXXXXX", size: 18, weight: .bold, color: .black, numOfLines: 1)
    
    private lazy var creatorLabel:UILabel = self.view.labelBuilder(text: "Pablo", size: 14, weight: .bold, color: .appBlueColor, numOfLines: 1)
    
    private lazy var timeEndsLabel:UILabel = self.view.labelBuilder(text: "08h 34m 59s", size: 14, weight: .bold, color: .black, numOfLines: 1)
    
    private lazy var creatorView:UIStackView = {
        return self.stackBuilder(header: "Created by",alignment: .left, label: self.creatorLabel)
    }()
    
    private lazy var timeView:UIStackView = {
        return self.stackBuilder(header: "Ends in",alignment: .right, label: self.timeEndsLabel)
    }()
    
    private lazy var artInfoSnippet:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(creatorView)
        stack.addArrangedSubview(timeView)
        
        NSLayoutConstraint.activate([
            creatorView.widthAnchor.constraint(equalTo: stack.widthAnchor,multiplier: 0.5, constant: -4),
            timeView.widthAnchor.constraint(equalTo: stack.widthAnchor,multiplier: 0.5, constant: -4)
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
        
        
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.heroHeaderView)
        
        self.setupImageView()
        
        self.scrollView.addSubview(self.titleView)
        if let title = self.nftArt?.title,title != ""{
            self.titleView.text = title
        }
    
        self.scrollView.addSubview(self.artInfoSnippet)
        
        self.scrollView.addSubview(self.biddingController)
        
        self.scrollView.addSubview(self.offerView)
        
        self.scrollView.addSubview(self.placeBidButton)

        self.view.addSubview(self.placeBidModal)
    }
    
    func setupImageView(){
        self.scrollView.addSubview(self.imageView)
        guard let safeImg = self.nftArt?.metadata?.image else{return}
//        self.imageView.updateImageView(url: safeImg)
        ImageDownloader.shared.fetchImage(urlStr: safeImg) { [weak self] result in
            switch result{
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.backgroundImageView.image = image
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
        self.imageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -50).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.35).isActive = true
        
        //Title
        self.titleView.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor).isActive = true
        self.titleView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 13).isActive = true
        self.titleView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor).isActive = true
        self.titleView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        //ArtInfoSnippet
        self.artInfoSnippet.leadingAnchor.constraint(equalTo: self.titleView.leadingAnchor).isActive = true
        self.artInfoSnippet.trailingAnchor.constraint(equalTo: self.titleView.trailingAnchor).isActive = true
        self.artInfoSnippet.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 12).isActive = true
        self.artInfoSnippet.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.artInfoSnippet.widthAnchor.constraint(equalTo: self.titleView.widthAnchor).isActive = true
        
        //BiddingController
        self.biddingController.leadingAnchor.constraint(equalTo: self.artInfoSnippet.leadingAnchor).isActive = true
        self.biddingController.trailingAnchor.constraint(equalTo: self.artInfoSnippet.trailingAnchor).isActive = true
        self.biddingController.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.biddingController.topAnchor.constraint(equalTo: self.artInfoSnippet.bottomAnchor, constant: 25).isActive = true
        
        
        //OffersView
//        self.offerView.topAnchor.constraint(equalTo: self.artInfoSnippet.bottomAnchor, constant: 25).isActive = true
//        self.offerView.leadingAnchor.constraint(equalTo: self.artInfoSnippet.leadingAnchor).isActive = true
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
            self.imageView.transform = CGAffineTransform.init(scaleX: self.imageScale, y: self.imageScale)
            self.imageView.layoutIfNeeded()
        }.startAnimation()
        
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: max(scrollView.contentOffset.y - 100,0))
        
        
    }
}
