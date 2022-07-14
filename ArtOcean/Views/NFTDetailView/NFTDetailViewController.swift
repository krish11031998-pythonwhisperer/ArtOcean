//
//  NFTDetailViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 29/05/2022.
//

import Foundation
import UIKit

class NFTDetailArtViewController:UIViewController{
    
// MARK: - Properties
	
	private var observer:NSKeyValueObservation?
    private var nftArt:NFTModel?
    private var placeBidModalLeadingAnchor:NSLayoutConstraint? = nil
    private var leadingOffScreen:CGFloat = 1000
    private let leadingOnScreen:CGFloat = 24
    private var imageScale:CGFloat = 1
	private let headerHeight:CGFloat = 460
    private var prices:[Double]? = []
	private var offers:NFTArtOffers = .init(repeating: .init(name: "John Doe", percent: "5.93", price: 12.03, time: 5), count: 5)
	private var tableView:UITableView?
	private var tableHeaderView:UIView?
    
	private lazy var placeBidButton:Container = {
		let button = CustomLabelButton(title: "Place a Bid", color: .white, backgroundColor: .appBlueColor)
		let container = Container(innerView: button, innerViewSize: .init(width: .zero, height: 52))
		button.delegate = self
		return container
	}()

	private var heroHeaderView:NFTHeroHeaderView?
	
	private lazy var artInteractiveInfoView:NFTArtInteractiveInfoView = .init(nft: self.nftArt ?? .init(contract: nil, id: nil, balance: nil, title: nil, description: nil, metadata: nil))
	
	private var imageView:CustomImageView = CustomImageView(cornerRadius: 16)
	
	private let creatorImage:CustomImageView = {
		let imageView = CustomImageView(cornerRadius: 16)
		imageView.image = .init(named: "profileImage")
		imageView.backgroundColor = .black
		return imageView
	}()
	
	private lazy var placeBidModal:NFTBiddingModal = {
		let view = NFTBiddingModal {
			self.closeModal()
		}
		return view
	}()
	

	private lazy var biddingController:Container = {
		let container:Container = .init(innerView: NFTBiddingController(), innerViewSize: .init(width:.zero,height: 82))
		return container
	}()
	
// MARK: -  Constructors
    init(nftArt:NFTModel) {
        self.nftArt = nftArt
        super.init(nibName: nil, bundle: nil)
        self.configNavigationBar()
        self.setupView()
//		NotificationCenter.default.addObserver(self, selector: #selector(scrollStarted), name: Notification.Name.chartViewScrollDidBegin, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		buildTable()
		buildHeroHeaderView()
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
			self?.prices = Array(repeating: 0, count: 15).compactMap({_ in Double.random(in: 1...5)})
			guard let safeDataSource = self?.buildDataSource() else { return }
			self?.tableView?.reload(with: safeDataSource)
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
    
	private func buildHeroHeaderView(){
		guard let safeNFTArt = nftArt else { return }
		heroHeaderView = .init(nft: safeNFTArt, height: headerHeight, handler: { [weak self] in
			self?.navigationController?.popViewController(animated: true)
		})
		view.addSubview(heroHeaderView!)
	}
	
        
//    private var creatorLabel:UILabel = {
//        return CustomLabel(text: "Pablo", size: 14, weight: .bold, color: .appBlueColor, numOfLines: 1,adjustFontSize: false)
//    }()
//    private var timeEndsLabel:UILabel = {
//        return CustomLabel(text: "08h 34m 59s", size: 14, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: false)
//    }()
//
//    private lazy var creatorView:UIStackView = {
//        return self.stackBuilder(header: "Created by",alignment: .left, label: self.creatorLabel)
//
//    }()
    
    
    
//    private lazy var artInfoSnippet:UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 8
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.addArrangedSubview(creatorView)
//        stack.addArrangedSubview(self.creatorImage)
//
//        NSLayoutConstraint.activate([
//            creatorImage.widthAnchor.constraint(equalToConstant:32),
//        ])
//
//        creatorView.setContentHuggingPriority(.init(259), for: .horizontal)
//        creatorView.setContentCompressionResistancePriority(.init(749), for: .horizontal)
//
//        return stack
//
//    }()
    
   
	
	func buildTable(){
		tableView = UITableView(frame: .zero, style: .grouped)
		tableView?.backgroundColor = .clear
		observer = tableView?.observe(\.contentOffset, changeHandler: {[weak self] target, _ in self?.updateOnScroll(target) })
		view.addSubview(tableView!)
		view.setContraintsToChild(tableView!, edgeInsets: .init(top: 0, left: 0, bottom: -40, right: 0))
		tableView?.separatorStyle = .none
		buildTableHeaderView()
		tableView?.contentInsetAdjustmentBehavior = .never
		tableView?.reload(with: buildDataSource())
	}
	
	func buildDataSource() -> TableViewDataSource{
		.init(section: [artIntroduction, priceHistorySection, attributeSection, offerSection].compactMap{ $0 })
	}
	
	private var artIntroduction:TableSection? {
		guard let safeNFT = nftArt else { return nil }
		return .init(rows: [TableRow<NFTArtIntroduction>(safeNFT)])
	}
	
	private var priceHistorySection:TableSection? {
		guard let prices = self.prices else { return nil }
		return .init(title:"Price History",rows: [TableRow<NFTChartViewCell>(.init(prices: prices, delegate: self))])
	}
	
	private var attributeSection:TableSection? {
		guard let attributes = nftArt?.metadata?.Attributes, !attributes.isEmpty else { return nil }
		return .init(title: "Attributes", rows: [TableRow<NFTAttributeView>(attributes.compactMap { $0 })])
	}
	
	private var offerSection:TableSection? {
		guard !offers.isEmpty else { return nil }
		return .init(title:"Offers",rows: offers.compactMap{ TableRow<NFTOfferTableViewCell>($0) })
	}
	
	private var backgroundimgView:CustomImageView = {
		let imageView = CustomImageView(cornerRadius: 0)
		return imageView
	}()
	
	private var imgView:CustomImageView = {
		let imageView = CustomImageView(cornerRadius: 16)
		return imageView
	}()
	
	func buildTableHeaderView(){
		tableHeaderView = UIView(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: headerHeight)))
		tableHeaderView?.backgroundColor = .clear
		tableView?.tableHeaderView = tableHeaderView
	}
    
    //MARK: - View Setups
    
    func setupView(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - ViewBuilder Helpers

extension NFTDetailArtViewController{
    
    func closeDetailView(){
        self.navigationController?.popViewController(animated: true)
    }

}


//MARK: - CustomLabelButtonDelegate

extension NFTDetailArtViewController:CustomButtonDelegate{
    func handleTap() {
        let animation = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.placeBidModalLeadingAnchor?.constant = self.leadingOnScreen
            self.view.layoutIfNeeded()
        }
        animation.startAnimation()
    }
    
    func closeModal(){
        let animation = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.placeBidModalLeadingAnchor?.constant = -self.leadingOffScreen
            self.leadingOffScreen = -self.leadingOffScreen
            self.view.layoutIfNeeded()
        }
        animation.startAnimation()
    }
}


//MARK: - ScrollViewDelegate
extension NFTDetailArtViewController{
    
    func updateOnScroll(_ scrollView: UIScrollView) {
		self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(scrollView.contentOffset.y - headerHeight * 0.75,0))
		let _ = heroHeaderView?.animateHeaderView(scrollView)
    }
}


//MARK: - ChartDelegate
extension NFTDetailArtViewController:NFTChartViewDelegate{
	func scrollStarted() {
		tableView?.isScrollEnabled = false
	}

	func scrollEnded() {
		print("(DEBUG) scrollEnded , enabling TableView scroll")
		tableView?.isScrollEnabled = true
	}

}

//MARK: - NotificationCenter
//extension NFTDetailArtViewController {
//
//	@objc func scrollStarted() {
//		tableView?.isScrollEnabled = false
//	}
//
//	@objc func scrollEnded() {
//		tableView?.isScrollEnabled = true
//	}
//}
