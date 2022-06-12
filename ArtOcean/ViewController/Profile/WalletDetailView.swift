//
//  WalletDetailView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/06/2022.
//

import Foundation
import UIKit

class WalletDetailView:UIViewController{
    
    private var items:[TransactionModel] = txns
    
    private let backButton:CustomButton = .backButton
    
    private let titleView:CustomLabel = .init(text: "Wallet", size: 18, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: true, autoLayout: false)
    
    private lazy var balanceViewStack:UIView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let titleView = CustomLabel(text: "CURRENT WALLET VALUE", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: true, autoLayout: false)
        titleView.textAlignment = .center
        profileValue.textAlignment = .center
        stack.addArrangedSubview(titleView)
        stack.addArrangedSubview(currentWalletBalanceView)
        stack.addArrangedSubview(profileValue)
        
        
        
        return stack
    }()
    
    private let profileValue:CustomLabel = .init(text: "0.0295 (1.34%)", size: 14, weight:.medium, color: .black, numOfLines: 1, adjustFontSize: true, autoLayout: false)
    
    
    private lazy var walletActionView:UIView = {
        let stack = StackedButtons(stackableButtons: [.receiveButton,.buyButton,.sendButton,.swapButton])
        
        return stack
    }()
    
    private let currentWalletBalance:CustomLabel = CustomLabel(text: "0.1345 ETH", size: 32, weight: .medium, color: .black, numOfLines: 1, adjustFontSize: true)
    
    private lazy var currentWalletBalanceView:UIView = {
        let stack = UIStackView()
        stack.spacing = 16
        currentWalletBalance.setContentHuggingPriority(.init(249), for: .horizontal)
        currentWalletBalance.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        
        let ethLogo = CustomImageView(named: "largeETHLogo", cornerRadius: 0)
        ethLogo.contentMode = .scaleAspectFit
        ethLogo.frame = .init(origin: .zero, size: .init(width:14,height:23))
        
        stack.addArrangedSubview(ethLogo)
        stack.addArrangedSubview(currentWalletBalance)
        
        stack.translatesAutoresizingMaskIntoConstraints = false

        
        return stack
    }()

    
    //MARK: - Recnt Activity Section
    private let seeAllButton:UILabel = {
        return CustomLabel(text: "See all", size: 14, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: true, autoLayout: false)
    }()
    
    private lazy var collectionHeader:UIView = {
        let view = UIStackView()
        view.axis = .horizontal
        
        let headerView = CustomLabel(text: "Recent Activity", size: 16, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: true, autoLayout: false)
        headerView.setContentHuggingPriority(.init(249), for: .horizontal)
        headerView.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        
        view.addArrangedSubview(headerView)
        view.addArrangedSubview(seeAllButton)
        
        return view
    }()
    
    private let tableView:UITableView = {
        let table = UITableView()
        
        table.separatorStyle = .singleLine
        table.separatorColor = .appGrayColor
        table.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        table.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        
        table.setContentHuggingPriority(.init(249), for: .vertical)
        table.setContentCompressionResistancePriority(.init(749), for: .vertical)
        table.showsVerticalScrollIndicator = false
        
        table.register(TransactionViewCell.self, forCellReuseIdentifier: TransactionViewCell.identifier)
        
        table.backgroundColor = .clear
        return table
    }()
    
    private lazy var recentActivity:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.addArrangedSubview(collectionHeader)
        stack.addArrangedSubview(tableView)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    
    //MARK: - ViewController
    init(){
        super.init(nibName: nil, bundle: nil)
        backButton.handler = self.popView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBar = navigationController?.navigationBar, navBar.isHidden{
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func setupViews(){
//        view.addSubview(currentWalletBalanceView)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(balanceViewStack)
        view.addSubview(walletActionView)
        view.addSubview(recentActivity)
    }
    
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleView
    }
    
    func popView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupLayout(){
        balanceViewStack.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 5).isActive = true
        balanceViewStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        walletActionView.topAnchor.constraint(equalToSystemSpacingBelow: balanceViewStack.bottomAnchor, multiplier: 3).isActive = true
        walletActionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 5).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: walletActionView.trailingAnchor, multiplier: 5).isActive = true
        
        recentActivity.topAnchor.constraint(equalToSystemSpacingBelow: walletActionView.bottomAnchor, multiplier: 5).isActive = true
        recentActivity.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: recentActivity.trailingAnchor, multiplier: 3).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: recentActivity.bottomAnchor,multiplier: 0).isActive = true
        
        
    }
}

//MARK: - ViewBuilders
extension WalletDetailView{
    
    func buttonBuilder(label:String,imageName:String,handler:@escaping () -> Void) -> UIStackView{
        let button = CustomButton(frame: .init(origin: .zero, size: .init(width: 54, height: 54)), cornerRadius: 27, name: imageName, handler: handler, autolayout: false)
        
        let buttonName = CustomLabel(text: label, size: 14, weight: .medium, color: .appPurpleColor, numOfLines: 1, adjustFontSize: false, autoLayout: false)
        
        buttonName.textAlignment = .center
        
        let stack = UIStackView()
        stack.axis = .vertical
        
        stack.addArrangedSubview(button)
        stack.addArrangedSubview(buttonName)
        
        return stack
    }
    
}

//MARK: - TableDelegate
extension WalletDetailView:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionViewCell.identifier, for: indexPath) as? TransactionViewCell else{
            
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            let label = CustomLabel(text: "Item #\(indexPath.row + 1)", size: 14, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: true, autoLayout: true)
            cell.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                label.leadingAnchor.constraint(equalToSystemSpacingAfter: cell.leadingAnchor, multiplier: 1),
                cell.trailingAnchor.constraint(equalToSystemSpacingAfter: label.trailingAnchor, multiplier: 1)
            ])
            
            return cell
        }
        
        cell.configureCell(txn: self.items[indexPath.row])
        
        return cell
    }
}
