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
    private var nftArt:NFTModel?
    private var placeBidModalLeadingAnchor:NSLayoutConstraint? = nil
    private var leadingOffScreen:CGFloat = 1000
    private let leadingOnScreen:CGFloat = 24
    private var imageScale:CGFloat = 1
	private let headerHeight:CGFloat = 460
    private var prices:[Double]? = []
	private var offers:NFTArtOffers = .init(repeating: .init(name: "John Doe", percent: "5.93", price: 12.03, time: 5), count: 5)
	private var navHeader: NFTDetailNavHeader = { NFTDetailNavHeader() }()
	private lazy var backButton:CustomButton = {
		let button = CustomButton.backButton
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
    }
    
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
		if let safeNavBar = self.navigationController?.navigationBar.isHidden,safeNavBar{
			self.navigationController?.setNavigationBarHidden(false, animated: true)
		}
		updateOnScroll(tableView)
		tableObserver = tableView.observe(\.contentOffset, changeHandler: {[weak self] target, _ in self?.updateOnScroll(target) })
		navbarObserver = navigationController?.navigationBar.observe(\.frame) {[weak self] target,_ in self?.updateNavBarOnTransformation(target)}
		loadChartData()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
    
    //MARK: -  NavigationItem
    private func configNavigationBar(){
        let navbarAppearence = UINavigationBarAppearance()
        navbarAppearence.backgroundColor = .white
        self.navigationController?.navigationBar.standardAppearance = .init(barAppearance: navbarAppearence)
        self.navigationController?.navigationBar.scrollEdgeAppearance = .init(barAppearance: navbarAppearence)
        self.navigationController?.navigationBar.isTranslucent = false
		navHeader.configureHeader(imageUrl: nftArt?.metadata?.image , title: nftArt?.Title ?? "")
        self.navigationItem.titleView = navHeader
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
		view.insertSubview(heroHeaderView!, at: 0)
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
		view.addSubview(tableView)
		buildTableHeaderView()
		tableView.reload(with: buildDataSource())
	}
	
	func buildDataSource() -> TableViewDataSource{
		.init(section: [artIntroduction, priceHistorySection, attributeSection, offerSection, modalButton].compactMap{ $0 })
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
	
	private var modalButton: TableSection? {
		return .init(rows: [TableRow<CustomTableWrapperView<ButtonViewCell>>(.init(title:"Bid".styled(font: .medium, color: .white, size: 15)) { [weak self] in
			let target = TestViewController(nftArtModel: self?.nftArt)
			let presentationController = PresentationViewController(target: target, from: self, clickOnDismiss: true)
			target.transitioningDelegate = presentationController
			target.modalPresentationStyle = .custom
			self?.present(target, animated: true) { presentationController }
		})])
	}
//
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
		backButton.handler = { [weak self] in
			self?.navigationController?.popViewController(animated: true)
		}
		tableHeaderView!.addSubview(backButton)
		tableHeaderView!.setFrameLayout(childView: backButton, alignment: .topLeading, paddingFactor: .init(vertical: 56, horizontal: 16))
		tableView.tableHeaderView = tableHeaderView
	}
	
	private func loadChartData() {
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
			self.prices = Array(repeating: 0, count: 15).compactMap({_ in Double.random(in: 1...5)})
			self.tableView.reload(with: self.buildDataSource())
		}
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
	@objc func updateOnScroll(_ scrollView: UIScrollView) {
		let navBarOffset = min(scrollView.contentOffset.y - headerHeight * 0.75,0)
		self.navigationController?.navigationBar.transform = .init(translationX: 0, y: navBarOffset)
		navHeader.animateIn(offset: navBarOffset)
//		let _ = heroHeaderView?.animateHeaderView(scrollView)
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

extension UIBarButtonItem {
	
	static func leftTitle(title: RenderableText) -> UIBarButtonItem {
		let label = UILabel()
		title.renderInto(target: label)
		return .init(customView: label)
	}
	
}

class TestViewController: UIViewController {
	
	private var nftArt: NFTModel?

	private lazy var mainStack: UIStackView = { .VStack(views: [], spacing: 10) }()
	
	init(nftArtModel: NFTModel?) {
		self.nftArt = nftArtModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupNavBar() {
		let title: UILabel = .init()
		let closeButton: CustomImageButton = .closeButton { [weak self] in
			self?.presentingViewController?.dismiss(animated: true)
		}
		
		let stack: UIStackView = .HStack(views: [title,.spacer(),closeButton], spacing: 10, aligmment: .center)
		
		(nftArt?.Title ?? "No Title").styled(font: .bold, color: .appBlackColor, size: 22.5).renderInto(target: title)
		
		mainStack.addArrangedSubview(stack)
		mainStack.setCustomSpacing(20, after: stack)
	}
	
	override func viewDidLoad() {
		view.backgroundColor = .white
		view.cornerRadius = 32
		view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
		preferredContentSize = .init(width: .totalWidth, height: .totalHeight * 0.8)
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
		view.addSubview(mainStack)
		view.setConstraintsToChild(mainStack, edgeInsets: .init(top: 24, left: 16, bottom: 16, right: 16))
		setupNavBar()
		setupImageView()
		mainStack.addArrangedSubview(.spacer())
	}
	
	private func setupImageView() {
		let imageView = CustomImageView(url: nftArt?.metadata?.image, cornerRadius: 16)
		imageView.setHeightWithPriority(preferredContentSize.height * 0.45,priority: .required)
		mainStack.addArrangedSubview(imageView)
	}
	
	@objc private func onTap() {
		presentingViewController?.dismiss(animated: true)
	}
	
}
