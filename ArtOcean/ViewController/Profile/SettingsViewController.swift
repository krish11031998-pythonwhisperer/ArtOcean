//
//  SettingsViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 08/08/2022.
//

import Foundation
import UIKit

fileprivate extension String {
	static var testUserImg: String { "https://weathereport.mypinata.cloud/ipfs/QmZJ56QmQpXQJamofJJYbR5T1gQTxVMhN5uHYfhvAmdFr8/85.png" }
}

enum SettingRowModel {
	
	case editProfile
	case changePassword
	case favorites
	case draft
	case wallet
	case logOut
}

extension SettingRowModel {
	
	var title: RenderableText {
		switch self {
		case .editProfile:
			return "Edit profile"
		case .changePassword:
			return "Change Password"
		case .favorites:
			return "Favorites"
		case .draft:
			return "Draft"
		case .wallet:
			return "Wallet"
		case .logOut:
			return "Log Out"
		}
	}
	
	var leadingImage: UIImage? {
		switch self {
		case .editProfile:
			return .customButtonImage(name: .user)?.roundedImage(cornerRadius: 32)
		case .changePassword:
			return .customButtonImage(name: .shieldCheck)?.roundedImage(cornerRadius: 32)
		case .favorites:
			return .customButtonImage(name: .heart)?.roundedImage(cornerRadius: 32)
		case .draft:
			return .customButtonImage(name: .pencil)?.roundedImage(cornerRadius: 32)
		case .wallet:
			return .customButtonImage(name: .creditCard)?.roundedImage(cornerRadius: 32)
		case .logOut:
			return .customButtonImage(name: .lockClosed, tintColor: .appRedColor, bgColor: .appRedColor.withAlphaComponent(0.15))?.roundedImage(cornerRadius: 32)
		}
	}
	
	var customInfoModel: CustomInfoButtonModel {
		let trailingImage: UIImage = .Catalogue.chevronRight.image.resized(.squared(16))
		return .init(leadingImg: leadingImage, title: title.styled(font: .medium, color: .appBlackColor, size: 14), trailingImage: trailingImage)
	}
}

class SettingViewController: UIViewController {
	
	private lazy var headerView: UIView = {
		let headerCaptionLabel = HeaderCaptionLabel(frame: .init(origin: .zero, size: .init(width: .totalWidth, height: 100)))
		headerCaptionLabel.configureLabel(
			img: .loadCache(.testUserImg)?.roundedImage(),
			title: "Krishna Venkatramani",
			subTitle: "@cryptoDon"
		)
		return headerCaptionLabel
	}()
	
	private lazy var tableView: UITableView = {
		.init(frame: .zero, style: .grouped)
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		tableView.reload(with: buildDataSource())
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		showNavBar()
		configNavbar()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		hideNavBar()
	}
	
	private func configNavbar() {
		let leftBarItem = UIBarButtonItem(customView: CustomImageButton.backButton { [weak self] in
			self?.navigationController?.popViewController(animated: true)
		})
		let titleView =  CustomLabel(text: "Settings", size: 22, weight: .bold, color: .black, numOfLines: 1)
		
		navigationItem.titleView = titleView
		navigationItem.leftBarButtonItem = leftBarItem
		
	}
	
	private var accountSettings: TableSection? {
		let row: [SettingRowModel] = [.editProfile,.changePassword]
		return .init(title: "Account Settings", rows: row.map { TableRow<CustomInfoButtonCell>($0.customInfoModel) })
	}
	
	private var preferenceSettings: TableSection? {
		let row: [SettingRowModel] = [.favorites,.draft,.wallet,.logOut]
		return .init(title: "Preferences", rows: row.map { TableRow<CustomInfoButtonCell>($0.customInfoModel) })
	}
	
	private func buildDataSource() -> TableViewDataSource {
		.init(section: [accountSettings, preferenceSettings].compactMap {$0})
	}
	
	private func setupUI() {
		view.backgroundColor = .appWhiteBackgroundColor
		view.addSubview(tableView)
		view.setSafeAreaConstraintsToChild(tableView, edgeInsets: .zero)
		tableView.tableHeaderView = headerView
		tableView.separatorStyle = .none
		tableView.backgroundColor = .appWhiteBackgroundColor
	}
	
}
