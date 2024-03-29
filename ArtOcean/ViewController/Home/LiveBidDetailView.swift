//
//  LiveBidDetailView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/05/2022.
//

import UIKit

class LiveBidDetailView: UIViewController  {
        
    
    private var nfts:[NFTModel]? = nil
    private var selectedNFT:NFTModel? = nil
	private var observer: NSKeyValueObservation?
	
    init(nfts:[NFTModel]? = NFTModel.testsArtData){
        self.nfts = nfts
        super.init(nibName: nil, bundle: nil)
		observer = liveBidTableView.observe(\.contentOffset) {[weak self] tableView, _ in self?.scrollViewDidScroll(tableView)}
        setupStatusBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var liveBidTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
		tableView.rowHeight = 320
        tableView.backgroundColor = .clear
		tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.setHeaderView(tableHeaderView)
        return tableView
    }()
    
    private lazy var tableHeaderView:UIView = {
		let view = UIView(frame: .zero)
		
        let label = UILabel()
		label.numberOfLines = 2
        
		let backButton = CustomImageButton.backButton {
			self.navigationController?.popViewController(animated: true)
		}
		
        var rootAttributedString:NSMutableAttributedString = .init(string:"Live", attributes: [NSAttributedString.Key.font:UIFont(name: CustomFonts.black.rawValue, size: 50)!])
        rootAttributedString.append(.init(string: "\nBid", attributes: [NSAttributedString.Key.font:UIFont(name: CustomFonts.medium.rawValue, size: 50)!]))
        
		NSMutableAttributedString(attributedString: rootAttributedString).renderInto(target: label)
		let stack: UIStackView = .VStack(views: [backButton, label], spacing: 12, aligmment: .leading)
		stack.setWidthForChildWithPadding(label, paddingFactor: 0, withPriority: .needed)
		
		view.addSubview(stack)
		view.setConstraintsToChild(stack, edgeInsets: .init(top: UIWindow.safeAreaInset.top, left: 24, bottom: 0, right: 24), withPriority: UILayoutPriority.needed.rawValue)
		
        return view
    }()
    

	private var nftSection:TableSection? {
		guard let validNFTs = nfts else { return nil }
		let rows:[CellProvider] = validNFTs.map { nft in
			let data: NFTArtCollectionViewCellData = .init(nft: nft) { [weak self] in
				self?.pushVC(nft: nft)
			}
			return TableRow<CustomTableWrapperView<NFTLiveBidView>>(data)
		}
		return .init(rows: rows)
	}
	
	private func buildDataSource() -> TableViewDataSource {
		let source: TableViewDataSource = .init(section: [nftSection].compactMap { $0 })
		return source
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(liveBidTableView)
        self.view.backgroundColor = .surfaceBackground
		liveBidTableView.reload(with: buildDataSource())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configNavigationBar()
        if selectedNFT != nil{
            selectedNFT = nil
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
        if !(navigationController?.navigationBar.isHidden ?? true), selectedNFT == nil{
			print("(DEBUG) Hiding the View!")
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
		if selectedNFT != nil { navigationController?.navigationBar.transform = .init(translationX: 0, y: -100) }
		
    }
    
    private func configNavigationBar(){
		if isNavBarHidden {
			navigationController?.setNavigationBarHidden(false, animated: true)
			scrollViewDidScroll(liveBidTableView)
		}
		let label: UILabel = .init()
		"Live Bid".heading3().renderInto(target: label)
		self.navigationItem.titleView = label
        self.navigationItem.leftBarButtonItem = self.backBarButton
    }
    
    private lazy var backBarButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        
		let backButton = CustomImageButton.backButton {
			self.navigationController?.popViewController(animated: true)
		}
        
        barButton.customView = backButton
        
        return barButton
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
	
    func setupLayout(){
		view.addViewAndSetConstraints(liveBidTableView, edgeInsets: .zero)
    }
	
	private func pushVC(nft:NFTModel) {
		selectedNFT = nft
		navigationController?.pushViewController(NFTDetailArtViewController(nftArt: nft), animated: true)
	}
}

//MARK: - CollectionViewDelegate
extension LiveBidDetailView{
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y - view.safeAreaInsets.top
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,yOffset))
    }
}
