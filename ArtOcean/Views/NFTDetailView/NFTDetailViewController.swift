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
		heroHeaderView = .init(nft: safeNFTArt, height: headerHeight)
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
		return .init(title:"Offers",rows: offers.rows)
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

	private lazy var mainStack: UIStackView = { .VStack(spacing: 10,aligmment: .center) }()
	private lazy var priceLabel: UILabel = { .init() }()
	private lazy var balanceLabel: UILabel = { .init() }()
	private lazy var scrollView: UIScrollView = { .init() }()
	
	private lazy var plusButton: CustomImageButton = {
		.init(name: .plus, addBG: false, tintColor: .appBlackColor, bgColor: .clear)
	}()
	
	private lazy var minusButton: CustomImageButton = {
		.init(name: .minus, addBG: false, tintColor: .appBlackColor, bgColor: .clear)
	}()
	
	private lazy var imageView: CustomImageView = {
		let imageView: CustomImageView = .init(url: nftArt?.metadata?.image, cornerRadius: 16)
		imageView.setHeightWithPriority(preferredContentSize.height * 0.15,priority: .required)
		imageView.setWidthWithPriority(preferredContentSize.width * 0.25,priority: .required)
		return imageView
	}()
	
	private lazy var headerInfoLabel: HeaderCaptionLabel = { .init() }()
	
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
		
		"Place A Bid".styled(font: .bold, color: .appBlackColor, size: 22.5).renderInto(target: title)
		
		mainStack.addArrangedSubview(stack)
		mainStack.setWidthForChildWithPadding(stack, paddingFactor: 0)
		mainStack.setCustomSpacing(20, after: stack)
	}
	
	override func viewDidLoad() {
		view.backgroundColor = .white
		view.cornerRadius = 32
		view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
		preferredContentSize = .init(width: .totalWidth, height: .totalHeight * 0.8)
		
		view.addSubview(scrollView)
		scrollView.setConstraintsWithParent(edgeInsets: .init(top: 24, left: 16, bottom: 16, right: 16),withPriority: 1000)
		scrollView.scrollIndicatorInsets = .init(vertical: 25, horizontal: 0)
		scrollView.addSubview(mainStack)
		scrollView.showsVerticalScrollIndicator = false
		
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		scrollView.setConstraintsToChild(mainStack, edgeInsets: .zero)
		scrollView.setEqualWidth(mainStack)
		
		setupNavBar()
		setupNFTDetailSection()
		attributes()
		setupPriceIndicator()
		placeBidButton()
		
	}
	
	private func setupNFTDetailSection() {
		
		guard let validNFT = nftArt else { return }
		
		let stack: UIStackView = .HStack(aligmment: .top)
		stack.addArrangedSubview(imageView)
		
		let title: RenderableText = validNFT.Title.styled(font: .medium, color: .appBlackColor, size: 20)
		let subTitle: RenderableText = (validNFT.id?.tokenId ?? "").styled(font: .regular, color: .appGrayColor, size: 13)
		
		headerInfoLabel.configureLabel(title: title, subTitle: subTitle)
		stack.addArrangedSubview(headerInfoLabel)
		mainStack.addArrangedSubview(stack)
		mainStack.setWidthForChildWithPadding(stack, paddingFactor: 0)
	}
	
	private func  setupPriceIndicator() {
		let stack: UIStackView = .HStack(spacing: 8,aligmment: .fill)
		
		"0.038 ETH".styled(font: .bold, color: .appBlackColor, size: 24).renderInto(target: priceLabel)
		
		let img = UIImageView(image: UIImage.Catalogue.eth.image.resized(.init(width: 12, height: 20)))
		img.contentMode = .scaleAspectFit
		[plusButton,.spacer(width: 16),img,priceLabel,.spacer(width: 16),minusButton].forEach { stack.addArrangedSubview($0) }
		
		stack.setHeightWithPriority(40)
		let borderedView = stack.marginedBorderedCard(borderColor: .appPurpleColor.withAlphaComponent(0.35))
	
		"Balance: {} ETH".replace(val: "0.045").styled(font: .medium, color: .appGrayColor, size: 14).renderInto(target: balanceLabel)
		
		mainStack.addArrangedSubview(.spacer(height: 25))
		mainStack.addArrangedSubview(borderedView)
		mainStack.addArrangedSubview(balanceLabel)
		mainStack.setCustomSpacing(25, after: balanceLabel)
	}
	
	private func attributes() {
		
		guard let validAttributes = nftArt?.metadata?.attributes else { return }
		
		let labels: [UIView] = validAttributes.filter { $0.trait_type != nil && $0.Value != nil }.map(\.attributeBlob)
		
		mainStack.buildFlexibleGrid(labels, innerSize: .init(width: preferredContentSize.width - 32, height: .zero), with: 10)
	}
	
	private func placeBidButton() {
		let button = CustomLabelButton(title: "Place a bid", font: .medium, size: 14, color: .white, handler: nil)
		mainStack.addArrangedSubview(button)
		mainStack.setWidthForChildWithPadding(button, paddingFactor: 0)
		button.setHeightWithPriority(40, priority: .required)
	}
	
	@objc private func onTap() {
		presentingViewController?.dismiss(animated: true)
	}
	
}

extension NSAttributedString {
	
	static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
		var copy = NSMutableAttributedString(attributedString: lhs)
		copy.append(rhs)
		return NSAttributedString(attributedString: copy)
	}
	
}
