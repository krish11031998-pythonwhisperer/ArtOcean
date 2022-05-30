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
    
    init(nftArt:NFTModel) {
        self.nftArt = nftArt
        
        super.init(nibName: nil, bundle: nil)
        
        
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = self.backBarButton
        self.navigationItem.titleView = self.view.labelBuilder(text: nftArt.title ?? "No Name", size: 20, weight: .bold, color: .black, numOfLines: 1)
        
        self.setupView()
        self.setupLayout()
        self.setupStatusBar()
    }
    
    //MARK: -  NavigationItem
    private lazy var backBarButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        
        let backButton = CustomButton.backButton
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
        scrollView.contentSize = .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var imageView:CustomImageView = CustomImageView(cornerRadius: 16)
    
    private lazy var titleView:UILabel = self.view.labelBuilder(text: "XXXXXX", size: 18, weight: .bold, color: .black, numOfLines: 1)
    
    private lazy var creatorLabel:UILabel = self.view.labelBuilder(text: "Pablo", size: 14, weight: .bold, color: .black, numOfLines: 1)
    
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
    
    private lazy var priceLabelView:UILabel = self.view.labelBuilder(text: "32.06 ETH", size: 14, weight: .bold, color: .black, numOfLines: 1)
    
    private lazy var priceLabelStackView:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        
        let ethButton = CustomButton.ethButton
        stack.addArrangedSubview(ethButton)
        stack.addArrangedSubview(self.priceLabelView)
        
        NSLayoutConstraint.activate([
            ethButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.3,constant: -6),
            self.priceLabelView.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.7,constant: -6)
        ])
        
        return stack
    }()

    private lazy var biddingView:UIView = {
        let stack = UIView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        let plusButton = CustomButton.plusButton
        let minusButton = CustomButton.minusButton
        stack.addSubview(plusButton)
        stack.addSubview(self.priceLabelStackView)
        stack.addSubview(minusButton)
        
        
        NSLayoutConstraint.activate([
            minusButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 16),
            minusButton.topAnchor.constraint(equalTo: stack.topAnchor, constant: 14),
            plusButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -16),
            plusButton.topAnchor.constraint(equalTo: stack.topAnchor, constant: 14),
            self.priceLabelStackView.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            self.priceLabelStackView.centerYAnchor.constraint(equalTo: stack.centerYAnchor)
        ])
        
        stack.layer.borderColor = UIColor.appBlueColor.withAlphaComponent(0.125).cgColor
        stack.layer.borderWidth = 1
        stack.layer.cornerRadius = 16
        
        return stack
    }()
    
    private lazy var offerView:Container = {
        let container = Container(header: "Offers", rightButtonTitle: "Last 7 Days", innerView: NFTOffersTableView(), innerViewSize: .init(width: UIScreen.main.bounds.width - 80, height: 300)) {
            print("(DEBUG) Clicked on last 7 days Button!")
        }
        return container
    }()
    
    
    //MARK: - View Setups
    
    func setupView(){
        
        self.view.addSubview(self.scrollView)
        
        self.setupImageView()
        
        self.scrollView.addSubview(self.titleView)
        if let title = self.nftArt?.title,title != ""{
            self.titleView.text = title
        }
        
        self.scrollView.addSubview(self.artInfoSnippet)
        
        self.scrollView.addSubview(self.biddingView)
        
        self.scrollView.addSubview(self.offerView)
    }
    
    func setupImageView(){
        self.scrollView.addSubview(self.imageView)
        guard let safeImg = self.nftArt?.metadata?.image else{return}
        self.imageView.updateImageView(url: safeImg)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayout(){
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        //ImageView
        self.imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 60).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -80).isActive = true
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
        self.biddingView.leadingAnchor.constraint(equalTo: self.artInfoSnippet.leadingAnchor).isActive = true
        self.biddingView.trailingAnchor.constraint(equalTo: self.artInfoSnippet.trailingAnchor).isActive = true
        self.biddingView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.biddingView.topAnchor.constraint(equalTo: self.artInfoSnippet.bottomAnchor, constant: 25).isActive = true
        
        
        //OffersView
        self.offerView.topAnchor.constraint(equalTo: self.biddingView.bottomAnchor, constant: 25).isActive = true
        self.offerView.leadingAnchor.constraint(equalTo: self.biddingView.leadingAnchor).isActive = true
        self.offerView.trailingAnchor.constraint(equalTo: self.biddingView.trailingAnchor).isActive = true

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
