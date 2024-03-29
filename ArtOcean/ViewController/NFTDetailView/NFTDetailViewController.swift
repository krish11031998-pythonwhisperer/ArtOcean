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
	
	private var tableObserver:NSKeyValueObservation?
	private var navbarObserver:NSKeyValueObservation?
	private var nftArt:NFTModel? = NFTStorage.selectedArt
    private var placeBidModalLeadingAnchor:NSLayoutConstraint? = nil
    private var leadingOffScreen:CGFloat = 1000
    private let leadingOnScreen:CGFloat = 24
    private var imageScale:CGFloat = 1
	private let headerHeight:CGFloat = 360
    private var prices:[Double]? = []
	private var offers:NFTArtOffers = .init(repeating: .init(name: "John Doe", percent: "5.93", price: 12.03, time: 5), count: 5)
	private var navHeader: NFTDetailNavHeader = { NFTDetailNavHeader() }()
	
	private lazy var backButton:CustomImageButton = {
		let button: CustomImageButton = .backButton { [weak self] in
			self?.navigationController?.popViewController(animated: true)
		}
		return button
	}()
	
	private var tableView:UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.contentInsetAdjustmentBehavior = .never
		return tableView
	}()
	
	private var tableHeaderView:UIView?
    
	private lazy var placeBidButton:Container = {
		let button = CustomLabelButton(title: "Place a Bid", color: .white, backgroundColor: .appBlueColor)
		let container = Container(innerView: button, innerViewSize: .init(width: .zero, height: 52))
		button.delegate = self
		return container
	}()

	private var heroHeaderView:NFTHeroHeaderView?
	
	private lazy var artInteractiveInfoView:NFTArtInteractiveInfoView = .init()
	
	private var imageView:CustomImageView = CustomImageView(cornerRadius: 16)
	
	private let creatorImage:CustomImageView = {
		let imageView = CustomImageView(cornerRadius: 16)
		imageView.image = .init(named: "profileImage")
		imageView.backgroundColor = .black
		return imageView
	}()
	
// MARK: -  Constructors
    init(nftArt:NFTModel? = nil) {
		self.nftArt = nftArt ?? NFTStorage.selectedArt
        super.init(nibName: nil, bundle: nil)
        self.configNavigationBar()
        self.setupView()
    }
    
	//MARK: - Overriden Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		buildTable()
		buildHeroHeaderView()
    }
    
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		view.setConstraintsToChild(tableView, edgeInsets: .init(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		showNavBar()
		setupStatusBar()
		updateOnScroll(tableView)
		tableObserver = tableView.observe(\.contentOffset, changeHandler: {[weak self] target, _ in self?.updateOnScroll(target) })
		navbarObserver = navigationController?.navigationBar.observe(\.frame) {[weak self] target,_ in self?.updateNavBarOnTransformation(target)}
		loadChartData()
		placeBidButtonFooter.showFooter()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
		placeBidButtonFooter.hideFooter()
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		tableView.reload(with: buildDataSource())
		configNavigationBar()
	}
	
    
    //MARK: -  NavigationItem
    private func configNavigationBar(){
		setupStatusBar()
		navHeader.configureHeader(imageUrl: nftArt?.metadata?.image , title: nftArt?.Title ?? "")
        self.navigationItem.titleView = navHeader
		backButton.buttonBackgroundColor = .surfaceBackground
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    private lazy var backBarButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem()
		
		let backButton = CustomImageButton.backButton { self.navigationController?.popViewController(animated: true) }
        
        barButton.customView = backButton
        
        return barButton
    }()
    
    //MARK: - Views
    
	private func buildHeroHeaderView(){
		guard let safeNFTArt = nftArt else { return }
		heroHeaderView = .init(nft: safeNFTArt, height: headerHeight)
		view.insertSubview(heroHeaderView!, at: 0)
	}
	
	private lazy var placeBidButtonFooter: StickyFooterView = {
		let view: CustomLabelButton = .init(title: "Place a bid",
											font: .bold, size: 14,
											color: .white,
											backgroundColor: .Catalogue.purple900.color) { [weak self] in
			self?.showBiddingView()
		}
		view.setHeightWithPriority(50, priority: .required)
		
		return StickyFooterView(innerView: view)
	}()
        
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
		view.addSubview(tableView)
		buildTableHeaderView()
		tableView.reload(with: buildDataSource())
		view.setConstraintsToChild(tableView, edgeInsets: .init(top: 0, left: 0, bottom: Self.safeAreaInset.bottom, right: 0))
	}
	
	func buildDataSource() -> TableViewDataSource{
		.init(section: [artIntroduction, priceHistorySection, attributeSection, offerSection].compactMap{ $0 })
	}
	
	private var artIntroduction:TableSection? {
		guard let safeNFT = nftArt else { return nil }
		let cellView = NFTArtIntroduction()
		let data: NFTArtSectionData = .init(nft: safeNFT, action: nil)
		
		cellView.configureCell(with: data)
		let viewModel: CustomTableCellModel = .init(innerView: cellView, edgeInsets: .zero, reload: true, action: cellView.resizeDescription)
		return .init(rows: [TableRow<CustomTableCell>(viewModel)])
	}
	
	private var priceHistorySection:TableSection? {
		guard let prices = self.prices else { return nil }
		return .init(title:"Price History",rows: [TableRow<NFTChartViewCell>(.init(prices: prices, delegate: self))])
	}
	
	private var attributeSection:TableSection? {
		guard let attributes = nftArt?.metadata?.Attributes, !attributes.isEmpty else { return nil }
		let stackView: AccordianStackView = .init(handler: nil)
		stackView.buildFlexibleGrid(attributes.map(\.attributeBlob), innerSize: .init(width: .totalWidth - 32, height: .zero), with: 10)
//		stackView.hideElement(2)
		//stackView.setHeightWithPriority(stackView.compressedFittingSize.height)
		return .init(title: "Attributes", rows: [TableRow<CustomTableCell>(.init(innerView: stackView, edgeInsets: .init(vertical: 10, horizontal: 16), reload: true, action: {
			stackView.animateAccordian()
		}))])
	}
	
	private var offerSection:TableSection? {
		guard !offers.isEmpty else { return nil }
		return .init(title:"Offers",rows: offers.rows)
	}
	
	private func showBiddingView() {
		let target = UINavigationController(rootViewController: NFTBiddingViewController(nftArtModel: self.nftArt))
		let presentationController = PresentationViewController(target: target, from: self, clickOnDismiss: true)
		target.transitioningDelegate = presentationController
		target.modalPresentationStyle = .custom
		present(target, animated: true) { presentationController }
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
		tableHeaderView!.backgroundColor = .clear
		tableHeaderView!.isUserInteractionEnabled = true
		backButton.handler = { [weak self] in self?.navigationController?.popViewController(animated: true) }
		tableHeaderView!.addSubview(backButton)
		tableHeaderView!.setFrameLayout(childView: backButton, alignment: .topLeading, paddingFactor: .init(vertical: 56, horizontal: 16))
		tableView.tableHeaderView = tableHeaderView
	}
	
	private func loadChartData() {
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
			self.prices = Array(repeating: 0, count: 15).compactMap({_ in Double.random(in: 1...5)})
			self.tableView.reload(with: self.buildDataSource())
		}
	}
    
    //MARK: - View Setups
    
    func setupView(){
        view.backgroundColor = .surfaceBackground
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
	@objc func updateOnScroll(_ scrollView: UIScrollView) {
		let navBarOffset = min(scrollView.contentOffset.y - headerHeight * 0.75,0)
		self.navigationController?.navigationBar.transform = .init(translationX: 0, y: navBarOffset)
		navHeader.animateIn(offset: navBarOffset)
		heroHeaderView?.animateHeaderView(scrollView)
    }
	
	@objc func updateNavBarOnTransformation(_ navBar:UINavigationBar) {
		//navBar.layer.opacity = Float((0...100).percent(abs(navBarOrigin.y), normalizeBelow: 0.001))
	}
}


//MARK: - ChartDelegate
extension NFTDetailArtViewController:NFTChartViewDelegate{
	func scrollStarted() {
		tableView.isScrollEnabled = false
	}

	func scrollEnded() {
		print("(DEBUG) scrollEnded , enabling TableView scroll")
		tableView.isScrollEnabled = true
	}

}


//MARK: - testing Toast VC

extension NSAttributedString {
	
	static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
		var copy = NSMutableAttributedString(attributedString: lhs)
		copy.append(rhs)
		return NSAttributedString(attributedString: copy)
	}
	
}
