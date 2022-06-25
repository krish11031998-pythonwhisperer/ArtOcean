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
    private var prices:[Double]!
    
    init(nftArt:NFTModel) {
        self.nftArt = nftArt
        super.init(nibName: nil, bundle: nil)
        prices = Array(repeating: 0, count: 25).compactMap({_ in Double.random(in: 1...5)})
        self.configNavigationBar()
        self.setupView()
        self.setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nftArt = nftArt else {
            return
        }
        self.titleView = CustomLabel(text: nftArt.Title, size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1, adjustFontSize: true)

        self.descriptionView = CustomLabel(text: nftArt.Description, size: 14, weight: .medium, color: .appGrayColor, numOfLines: 3, adjustFontSize: false)

        self.heroHeaderView = NFTHeroHeaderView(nft: nftArt,height: 200 + UIScreen.main.bounds.height * 0.175, handler: {
            self.navigationController?.popViewController(animated: true)
        })
        
        if let safeAttributes = nftArt.metadata?.attributes{
            self.attributesTable = .init(attributes: safeAttributes)
        }
        
    }
    
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let safeNavBar = self.navigationController?.isNavigationBarHidden,safeNavBar{
			self.navigationController?.setNavigationBarHidden(false, animated: true)
		}
		self.navigationController?.navigationBar.transform = .init(translationX: 0, y: -100)
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
			self?.prices = self?.prices.compactMap({_ in Double.random(in: 1...5)})
			print("(DEBUG) Updating the chart with new dataPoints : ",self?.prices)
			self?.chartView.updateUI(self!.prices!)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
	}
	
    
    //MARK: -  NavigationItem
    private func configNavigationBar(){
        //navigationBar
        let navbarAppearence = UINavigationBarAppearance()
        navbarAppearence.backgroundColor = .white
        self.navigationController?.navigationBar.standardAppearance = .init(barAppearance: navbarAppearence)
        self.navigationController?.navigationBar.scrollEdgeAppearance = .init(barAppearance: navbarAppearence)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.titleView = self.view.labelBuilder(text: self.nftArt?.Title ?? "", size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1)
        self.navigationItem.leftBarButtonItem = self.backBarButton
        
    }
    
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
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var placeBidButton:Container = {
        let button = CustomLabelButton(title: "Place a Bid", color: .white, backgroundColor: .appBlueColor)
        let container = Container(innerView: button, innerViewSize: .init(width: .zero, height: 52))
        button.delegate = self
        return container
    }()

    private var heroHeaderView:NFTHeroHeaderView!
    
    private lazy var artInteractiveInfoView:NFTArtInteractiveInfoView = .init(nft: self.nftArt ?? .init(contract: nil, id: nil, balance: nil, title: nil, description: nil, metadata: nil))
    
    private var imageView:CustomImageView = CustomImageView(cornerRadius: 16)
        
    private var titleView:UILabel!
    
    private var descriptionView:UILabel!
    
    private lazy var titleDescriptionView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleView,descriptionView])
        stack.axis = .vertical
        stack.spacing = 8
        
        descriptionView.setContentHuggingPriority(.init(249), for: .vertical)
        descriptionView.setContentCompressionResistancePriority(.init(749), for: .vertical)

        return stack
    }()
    
    private var creatorLabel:UILabel = {
        return CustomLabel(text: "Pablo", size: 14, weight: .bold, color: .appBlueColor, numOfLines: 1,adjustFontSize: false)
    }()
    private var timeEndsLabel:UILabel = {
        return CustomLabel(text: "08h 34m 59s", size: 14, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: false)
    }()
    
    private lazy var creatorView:UIStackView = {
        return self.stackBuilder(header: "Created by",alignment: .left, label: self.creatorLabel)
        
    }()
    
    private let creatorImage:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 16)
        imageView.image = .init(named: "profileImage")
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private lazy var artInfoSnippet:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(creatorView)
        stack.addArrangedSubview(self.creatorImage)
        
        NSLayoutConstraint.activate([
            creatorImage.widthAnchor.constraint(equalToConstant:32),
        ])

        creatorView.setContentHuggingPriority(.init(259), for: .horizontal)
        creatorView.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        
        return stack
        
    }()
    
    
    private var attributesTable:NFTAttributeView? = nil
    
    private lazy var offerView:Container = {
        let container = Container(header: "Offers", rightButtonTitle: "Last 7 Days", innerView: NFTOffersTableView(), innerViewSize: .init(width: .zero, height: 350),paddingToHeaderView: false) {
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
    
    private var stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 24, left: 24, bottom: 24, right: 24)
        return stackView
    }()
    
    private lazy var biddingController:Container = {
        let container:Container = .init(innerView: NFTBiddingController(), innerViewSize: .init(width:.zero,height: 82))
        return container
    }()

    private lazy var chartView:ChartView = {
        let chartView = ChartView(data: prices)
        chartView.chartDelegate = self
        return chartView
    }()
    
    private lazy var priceChartLabel:CustomLabel = {
        let label = CustomLabel(text: String(format: "%.2f", prices.last ?? 0) + " ETH", size: 20, weight: .medium, color: .appGrayColor, numOfLines: 1)
        return label
    }()
    
    private lazy var priceChangeLabel:CustomLabel = {
        guard let first = prices.first , let last = prices.last else {return CustomLabel(text: "No Price", color: .black, numOfLines: 1)}
        let label = CustomLabel(text: String(format: "%.2f", (last - first)/last), size: 13, weight: .medium, color: last > first ? .appGreenColor : .appRedColor, numOfLines: 1, adjustFontSize: true, autoLayout: false)
        return label
    }()
    
    private lazy var chartPriceView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        
        let priceHeader = CustomLabel(text: "Price History", size: 18, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: false, autoLayout: false)
    
        let priceValueStack = UIStackView()
        priceValueStack.axis = .horizontal
        priceValueStack.spacing = 8
        priceValueStack.addArrangedSubview(priceChartLabel)
        priceValueStack.addArrangedSubview(priceChangeLabel)
        
        priceValueStack.alignment = .firstBaseline
        
        priceChangeLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        priceChangeLabel.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        
        
        let priceView:UIStackView = UIStackView(arrangedSubviews: [priceHeader,priceValueStack])
        priceView.axis = .vertical
        priceView.spacing = 8
        
        stack.addArrangedSubview(priceView)
        stack.addArrangedSubview(chartView)
        
        return stack
    }()
    
    //MARK: - View Setups
    
    func setupView(){
    
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.view.addSubview(self.scrollView)
        
        self.setupImageView()
        
        self.scrollView.addSubview(stackView)
                
        stackView.addArrangedSubview(artInteractiveInfoView)
                
        stackView.addArrangedSubview(titleDescriptionView)
    
        stackView.addArrangedSubview(artInfoSnippet)
       
        stackView.addArrangedSubview(biddingController)
       
        stackView.addArrangedSubview(chartPriceView)
        
        stackView.addArrangedSubview(offerView)
        
        if let safeAttributeTable = self.attributesTable{
            stackView.addArrangedSubview(safeAttributeTable)
        }
       
        stackView.addArrangedSubview(placeBidButton)

        self.view.addSubview(self.placeBidModal)
    }
    
    func setupImageView(){
        guard let safeImg = self.nftArt?.metadata?.image else{return}
        DispatchQueue.global().async {
            self.heroHeaderView.updateImages(url:safeImg)
        }

        scrollView.addSubview(heroHeaderView)
        
        heroHeaderView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        heroHeaderView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayout(){

        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: -self.view.safeAreaInsets.top).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: heroHeaderView.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 0).isActive = true

        artInfoSnippet.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
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
        heroHeaderView.animateHeaderView(scrollView)

        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(scrollView.contentOffset.y - 100,0))
        
    }
}


//MARK: - ChartDelegate
extension NFTDetailArtViewController:ChartDelegate{
    
    func resetPriceAndChange(){
        if let first = prices.first,let last = prices.last {
            DispatchQueue.main.async {[weak self] in
                let percent = CGFloat(last - first)/CGFloat(last)
                self?.priceChartLabel.text = String(format: "%.2f", last) + " ETH"
                self?.priceChangeLabel.text = String(format: "%.2f", percent * 100) + "%"
                self?.priceChartLabel.textColor = .appGrayColor
                self?.priceChangeLabel.textColor = percent > 0 ? .appGreenColor : .appRedColor
            }
        }
    }
    
    func selectedPrice(_ price: Double) {
        if let last = prices.last{
            DispatchQueue.main.async {[weak self] in
                let percent = CGFloat(price - last)/CGFloat(price)
                self?.priceChartLabel.text = String(format: "%.2f", price) + " ETH"
                self?.priceChangeLabel.text = String(format: "%.2f", percent * 100) + "%"
                self?.priceChangeLabel.textColor = percent > 0 ? .appGreenColor : .appRedColor
                self?.priceChartLabel.textColor = last > price ? .appRedColor : .appGreenColor
            }
        }
    }
    
    func scrollStart() {
        scrollView.isScrollEnabled = false
        resetPriceAndChange()
    }
    
    func scrollEnded() {
        scrollView.isScrollEnabled = true
        resetPriceAndChange()
    }
    
}
