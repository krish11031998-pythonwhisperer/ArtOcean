//
//  HomeViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class HomeViewController: UIViewController {
    

	private var tableView:UITableView?
	private var nfts:[NFTModel]?
	private lazy var datasource:TableViewDataSource = { buildDataSource() }()

	
	func buildDataSource() -> TableViewDataSource{
		.init(section: [liveBidCollection, topCollection, hotItems, topSeller, popularItems].compactMap{ $0 })
	}
	
	private var liveBidCollection:TableSection? {
		guard let safeNFTs = nfts, !safeNFTs.isEmpty else { return nil }
		var data:NFTArtCollectionModel = .init(nfts: safeNFTs, size: NFTArtCollection.largeCard)
		data.action = { [weak self] art in self?.viewNFT(art: art) }
		let rows:[CellProvider] = [TableRow<NFTArtCollectionCell>(data)]
		let headerView = ContainerHeaderView(title: "Live Bid", rightButtonTitle: "View All", buttonHandler: { [weak self] in self?.pushSeeAllArtVC() })
		return TableSection(headerView: headerView , rows: rows)
	}
	
	private var hotItems:TableSection? {
		guard let safeNFTs = nfts, !safeNFTs.isEmpty else { return nil }
		var data:NFTArtCollectionModel = .init(nfts: safeNFTs, size: NFTArtCollection.smallCard)
		data.action = { [weak self] art in self?.viewNFT(art: art) }
		let rows:[CellProvider] = [TableRow<NFTArtCollectionCell>(data)]
		let headerView = ContainerHeaderView(title: "Hot Items", rightButtonTitle: "View All", buttonHandler: { [weak self] in self?.pushSeeAllArtVC() })
		return TableSection(headerView: headerView , rows: rows)
	}
	
	private var popularItems:TableSection? {
		guard let safeNFTs = nfts, !safeNFTs.isEmpty else { return nil }
		var data:NFTArtCollectionModel = .init(nfts: safeNFTs, size: NFTArtCollection.smallCard)
		data.action = { [weak self] art in self?.viewNFT(art: art) }
		let rows:[CellProvider] = [TableRow<NFTArtCollectionCell>(data)]
		let headerView = ContainerHeaderView(title: "Popular Items", rightButtonTitle: "View All", buttonHandler: { [weak self] in self?.pushSeeAllArtVC() })
		return TableSection(headerView: headerView , rows: rows)
	}

	
	private var topCollection:TableSection{
		let headerView = ContainerHeaderView(title: "Top Collection", rightButtonTitle: "View All") { [weak self] in self?.pushSeeAllArtVC() }
		return .init(headerView: headerView, rows: Array(repeating: TopCollectionData.test, count: 5).compactMap{ TableRow<TopCollectionTableCell>($0) })
	}
	
    private lazy var artTypes:TableSection? = {
		return .init(rows: [TableRow<NFTArtTypeCollectionViewCell>(NFTArtType.allType)])
    }()
	
	private var topSeller:TableSection?{
		let headerView = ContainerHeaderView(title: "Top Seller", rightButtonTitle: "View all") { [weak self] in self?.pushSeeAllArtVC() }
		let rowData = Array(repeating: SellerData.test, count: 15)
		let row = [TableRow<TopSellerCollectionViewTableCell>(rowData)]
		return .init(headerView: headerView, rows: row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		buildTableView()
		tableView?.reload(with: datasource)
        self.setupStatusBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		loadNFT()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
	
	func buildTableView(){
		tableView = UITableView(frame: .zero, style: .grouped)
		tableView?.backgroundColor = .clear
		tableView?.tableHeaderView = headerView
		tableView?.separatorStyle = .none
		view.addSubview(tableView!)
		view.setContraintsToChild(tableView!, edgeInsets: .zero)
	}
	
	func loadNFT(){
		guard nfts == nil else {return}
		AlchemyAPI.shared.getNftsFromFile(fileName: "nft") { [weak self] result in
			switch result{
			case .success(let nfts):
				let filterNFTS = nfts.compactMap({$0.metadata?.image?.contains("https") ?? false ? $0 : nil})
				self?.nfts = (filterNFTS.count > 5 ? Array(filterNFTS[0...4]) : filterNFTS)
				print("(DEBUG) Got Data Successffuly !")
				DispatchQueue.main.async {
					guard let safeDatasource = self?.buildDataSource() else { return }
					self?.tableView?.reload(with: safeDatasource)
				}
			case .failure(let err):
				print("(error) err : ",err.localizedDescription)
			}
		}
	}
	
	private func viewArt(_ nft:NFTModel){
		navigationController?.pushViewController(NFTDetailArtViewController(nftArt: nft), animated: true)
	}
	
    
	private var headerView:UIView {

		let stackView = UIStackView(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 226)))
		stackView.axis = .vertical
		stackView.spacing = 24
		let artTypeCollection = NFTArtTypeCollectionView()
		artTypeCollection.configureCollection(NFTArtType.allType)
		stackView.addArrangedSubview(artTypeCollection)
		stackView.addArrangedSubview(bannerImageView)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
		return stackView
	}
	
    func popLivBidVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func pushSeeAllArtVC(){
        let liveBidVC = LiveBidDetailView()
        self.navigationController?.pushViewController(liveBidVC, animated: true)
    }
    
    private lazy var bannerImageView:UIView = {
        let view = UIView()
    
        let imageView = UIImageView()
        if let safeImg = UIImage(named: "BannerSkeleton"){
            imageView.image = safeImg
        }
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor,multiplier: 1).isActive = true
        view.trailingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor,multiplier: 1).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //LearnMoreImage
        let learnMoreBannerImage = UIImageView()
        learnMoreBannerImage.translatesAutoresizingMaskIntoConstraints = false
        learnMoreBannerImage.contentMode = .scaleAspectFit
        learnMoreBannerImage.image = .init(named: "LearnMoreBannerImage")
        imageView.addSubview(learnMoreBannerImage)
        
        learnMoreBannerImage.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -20).isActive = true
        learnMoreBannerImage.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 24).isActive = true
        learnMoreBannerImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        learnMoreBannerImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //titlView
        let bannerTitle = self.view.labelBuilder(text: "Collect and Sell extraordinary NFTs", size: 18, weight: .bold, color: .appWhiteBackgroundColor, numOfLines: 2, adjustFontSize: false)
        imageView.addSubview(bannerTitle)
        bannerTitle.leadingAnchor.constraint(equalTo: learnMoreBannerImage.leadingAnchor).isActive = true
        bannerTitle.topAnchor.constraint(equalTo: imageView.topAnchor,constant:20).isActive = true
        bannerTitle.bottomAnchor.constraint(equalTo: learnMoreBannerImage.topAnchor, constant: -24).isActive = true
        bannerTitle.widthAnchor.constraint(equalToConstant: 185).isActive = true
        
		view.heightAnchor.constraint(equalToConstant: 132).isActive = true
		
        return view
    }()
    
    private var stackView:UIStackView = {
        let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
//    func setupLayout(){
//
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 3).isActive = true
//
////        self.artTypes.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        self.bannerImageView.heightAnchor.constraint(equalToConstant: 132).isActive = true
//
//    }
    
}

//MARK: - NFTLiveBidCollectionDelegate
extension HomeViewController:NFTLiveBidCollectionDelegate{
    func viewAll(allArt: [NFTModel]) {
        let liveBidVC = LiveBidDetailView(nfts: allArt)
        self.navigationController?.pushViewController(liveBidVC, animated: true)
    }
    
    func viewNFT(art: NFTModel) {
        print("(DEBUG) selected An Art : ",art.title ?? "")
        self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: art), animated: true)
    }
}
