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
    
    init(nfts:[NFTModel]? = NFTModel.testsArtData){
        self.nfts = nfts
        super.init(nibName: nil, bundle: nil)
        setupStatusBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var liveBidTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "customCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = tableHeaderView
        return tableView
    }()
    
    private let tableHeaderView:UIView = {
        let view = UIView()
        view.frame = .init(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 150))
        let label = CustomLabel(text: "Live\nBid", size: 50, weight: .bold, color: .black, numOfLines: 2, adjustFontSize: true, autoLayout: true)
        
        var rootAttributedString:NSMutableAttributedString = .init(string:"Live", attributes: [NSAttributedString.Key.font:UIFont(name: CustomFonts.black.rawValue, size: 50)!])
        rootAttributedString.append(.init(string: "\nBid", attributes: [NSAttributedString.Key.font:UIFont(name: CustomFonts.medium.rawValue, size: 50)!]))
        
        label.attributedText = NSMutableAttributedString(attributedString: rootAttributedString)
        view.backgroundColor = .clear
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            label.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 1),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
        
        return view
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(liveBidTableView)
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.isNavigationBarHidden ?? false{
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.configNavigationBar()
        if selectedNFT != nil{
            selectedNFT = nil
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !(navigationController?.navigationBar.isHidden ?? true){
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func configNavigationBar(){
        if let safeNavbar = self.navigationController?.navigationBar,safeNavbar.isHidden{
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.transform = .init(translationX: 0, y: -view.safeAreaInsets.top)
        }
        self.navigationItem.titleView = CustomLabel(text: "Live Bid", size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1)
        self.navigationItem.leftBarButtonItem = self.backBarButton
    }
    
    private lazy var backBarButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        
        let backButton = CustomButton.backButton
        backButton.handler = {
            self.navigationController?.popViewController(animated: true)
        }
        
        barButton.customView = backButton
        
        return barButton
    }()
    
    @objc func handleBackButtonTap(){
        print("(DEBUG) Tap Back Button was pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupLayout()
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: -200)
    }
    
    func setupLayout(){
        liveBidTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        liveBidTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        liveBidTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        liveBidTableView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
    }
}

//MARK: - CollectionViewDelegate
extension LiveBidDetailView:UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y - view.safeAreaInsets.top
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,yOffset))
    }
}

//MARK: - CollectionTableView
extension LiveBidDetailView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nfts?.count ?? 1
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell else{
            return UITableViewCell()
        }
        if let safeNFT = nfts?[indexPath.row]{
            let contentView = NFTLiveBidCellView(nft: safeNFT,largeCard: true)
            cell.configureCell(safeNFT, view: contentView,leadingMultiple: 2,trailingMultiple: 2)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let safeNFT = nfts?[indexPath.row] as? NFTModel,selectedNFT != safeNFT{
            selectedNFT = safeNFT
            navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
            navigationController?.pushViewController(NFTDetailArtViewController(nftArt: safeNFT), animated: true)
        }
    }
}
