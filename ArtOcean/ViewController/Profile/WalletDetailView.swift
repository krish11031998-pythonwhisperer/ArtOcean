//
//  WalletDetailView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/06/2022.
//

import Foundation
import UIKit

fileprivate extension CustomImageButton {
	
	static func walletButton(name: UIImage.Catalogue) -> CustomImageButton {
		let button = CustomImageButton(name: name, frame: .squared(55), addBG: true, tintColor: .appPurpleColor, bgColor: .appPurple50Color, bordered: false, handler: nil)
		button.imageView?.cornerRadius = CGFloat(55).half
		return button
	}
}

fileprivate extension UIImage.Catalogue {
	
	var buttonName: String {
		switch self {
			case .arrowDown:
				return "Received"
			case .creditCard:
				return "Buy"
			case .arrowUpRight:
				return "Send"
			case .switchHorizontal:
				return "Swap"
			default:
				return ""
		}
	}
	
	var button: UIView {
		let button = CustomImageButton.walletButton(name: self)
		let label = CustomLabel(text: buttonName, size: 14, weight: .medium, color: .appPurpleColor, numOfLines: 1)
		let stack = UIStackView(arrangedSubviews: [button,label])
		stack.alignment = .center
		stack.axis = .vertical
		stack.spacing = 12
		return stack.embedInView(edges: .init(vertical: 0, horizontal: 10), priority: .defaultHigh)
	}
}

fileprivate extension TransactionModel {
	
	var imageButtonInfoModel: CustomInfoButtonModel {
		.init(title: (artModel?.title ?? "").replace(val: "XXXX").body2Medium(),
			  subTitle: "Owner".body3Medium(color: .subtitleColor),
			  infoTitle: type.rawValue.capitalized.body2Medium(),
			  infoSubTitle: day.body3Medium(color: .subtitleColor),
			  leadingImageUrl: artModel?.metadata?.image,
			  style: .rounded(8),
			  imgSize: .squared(40)
		) {
			print("(DEBUG) Clicked !")
		}
	}
	
	var txnButtonInfoModel: CustomInfoButtonModel {
		let img: UIImage = type == .send ? .Catalogue.arrowUp.image.withTintColor(.appGreen) : .Catalogue.arrowUpRight.image.withTintColor(.appRed)
		
		let imgView: UIImageView = .init(frame: .init(origin: .zero, size: .squared(40)))
		imgView.image = img.resized(imgView.frame.size * 0.5)
		imgView.contentMode = .center
		imgView.backgroundColor = .greyscale200
		imgView.cornerRadius = 20
		
		return .init(leadingImg: imgView.snapshot,
					 title: "\(String(format: "%.2f", value)) ETH".body3Medium(),
					 infoTitle: type.rawValue.body2Medium(),
					 infoSubTitle: day.body3Medium(color: .subtitleColor),
					 style: .circle(.squared(40).halfed) ,
					 imgSize: .squared(40)
		) {
			print("(DEBUG) Clicked !")
		}
	}
	
	var tableCell: CellProvider {
		var model: CustomInfoButtonModel = .init()
		
		if type == .buy || type == .sell, let _ = artModel {
			model = imageButtonInfoModel
		} else {
			model = txnButtonInfoModel
		}
		
		return TableRow<CustomInfoButtonCell>(model)
	}
	
}

class WalletDetailView:UIViewController{
    
    private var items:[TransactionModel] = txns
    
	private lazy var backButton:CustomImageButton = {
		let button: CustomImageButton = .backButton { [weak self] in
			self?.navigationController?.popViewController(animated: true)
		}
		return button
	}()
    
	private lazy var titleView:UILabel = {
		let label = UILabel()
		"Wallet".heading4().renderInto(target: label)
		return label
	}()
    
    private lazy var balanceViewStack:UIView = {
		let stack: UIStackView = .VStack(spacing: 8, aligmment: .center)
        
        let titleView = CustomLabel(text: "CURRENT WALLET VALUE", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: true, autoLayout: false)
        titleView.textAlignment = .center
        profileValue.textAlignment = .center
        stack.addArrangedSubview(titleView)
        stack.addArrangedSubview(currentWalletBalance)
        stack.addArrangedSubview(profileValue)
	
        
        return stack
    }()
    
    private let profileValue: UILabel = {
		let label: UILabel = .init()
		"0.0295 (1.34%)".body2Medium(color: .appGreen).renderInto(target: label)
		return label
	}()
    
    
    private lazy var walletActionView:UIView = {
		let images: Array<UIImage.Catalogue> = [.arrowDown,.creditCard,.arrowUpRight,.switchHorizontal]
		let buttons: [UIView] = images.map(\.button)
	
        let stack = UIStackView(arrangedSubviews: buttons)
		stack.alignment = .center
		stack.spacing = 0
        return stack
    }()
    
	private let currentWalletBalance: UILabel = {
		let label: UILabel = .init()
		"0.12345 ETH".heading1().renderInto(target: label)
		return label
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
		let table = UITableView(frame: .zero, style: .grouped)
		table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
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
	
	private func buildDataSource() -> TableViewDataSource {
		.init(section: [TableSection(title: "Recent Activity", rows: items.map(\.tableCell))])
	}
    
	private lazy var walletHeaderView: UIView = {
		let views: [UIView] = [.spacer(height: 24),balanceViewStack, walletActionView, .spacer(height: 40)]
		let stack: UIStackView = .VStack(views: views, spacing: 32, aligmment: .center)
		return stack
	}()
    
    //MARK: - ViewController
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .surfaceBackground
        setupNavigationBar()
        setupViews()
//        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBar = navigationController?.navigationBar, navBar.isHidden{
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func setupViews(){
		tableView.tableHeaderView = walletHeaderView
		let headerViewFrame: CGRect = .init(origin: .zero, size: .init(width: .totalWidth, height: walletHeaderView.compressedFittingSize.height))
		tableView.tableHeaderView?.frame = headerViewFrame
		view.addSubview(tableView)
		tableView.reload(with: buildDataSource())
		view.setConstraintsToChild(tableView, edgeInsets: .zero)
    }
    
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleView
    }
    
    func popView(){
        self.navigationController?.popViewController(animated: true)
    }
}

