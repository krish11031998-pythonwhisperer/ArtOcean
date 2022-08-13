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

class SettingViewController: UIViewController {
	
	private lazy var headerView: UIView = {
		let headerCaptionLabel = HeaderCaptionLabel(frame: .init(origin: .zero, size: .init(width: .totalWidth, height: 100)))
		headerCaptionLabel.configureLabel(img: .loadCache(.testUserImg)?.roundedImage(),title: "Krishna Venkatramani", subTitle: "@cryptoDon", info: "Interesting")
		return headerCaptionLabel
	}()
	
	private lazy var tableView: UITableView = {
		.init()
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
		let navbarAppearence = UINavigationBarAppearance()
		navbarAppearence.backgroundColor = .clear
		navigationController?.navigationBar.standardAppearance = .init(barAppearance: navbarAppearence)
		navigationController?.navigationBar.scrollEdgeAppearance = .init(barAppearance: navbarAppearence)
		navigationController?.navigationBar.isTranslucent = false
		
		let leftBarItem = UIBarButtonItem(customView: CustomImageButton.closeButton { [weak self] in self?.navigationController?.popViewController(animated: true) })
		let titleView =  CustomLabel(text: "Settings", size: 22, weight: .bold, color: .black, numOfLines: 1)
		
		navigationItem.titleView = titleView
		navigationItem.leftBarButtonItem = leftBarItem
		
	}
	
	private var accountSettings: TableSection? {
		let buttons: [CustomInfoButtonModel] = [
			.init(leadingImg: .customButtonImage(name: .userOutline)?.roundedImage(),title: "Edit profile".styled(font: .medium, color: .appBlackColor, size: 14), trailingImage: .Catalogue.chevronRight.image.resized(.squared(16))),
			.init(leadingImg: .customButtonImage(name: .shieldCheck)?.roundedImage(),title: "Change Password".styled(font: .medium, color: .appBlackColor, size: 14), trailingImage: .Catalogue.chevronRight.image.resized(.squared(16)))
		]
		return .init(title: "Account Settings", rows: buttons.map { TableRow<CustomInfoButtonCell>($0) })
	}
	
	private var preferenceSettings: TableSection? {
		let buttons: [CustomInfoButtonModel] = [
			.init(leadingImg: .customButtonImage(name: .heart)?.roundedImage(),title: "Favorites".styled(font: .medium, color: .appBlackColor, size: 14), trailingImage: .Catalogue.chevronRight.image.resized(.squared(16))),
			.init(leadingImg: .customButtonImage(name: .shieldCheck)?.roundedImage(),title: "Draft".styled(font: .medium, color: .appBlackColor, size: 14), trailingImage: .Catalogue.chevronRight.image.resized(.squared(16))),
			.init(leadingImg: .customButtonImage(name: .creditCard)?.roundedImage(),title: "Wallet".styled(font: .medium, color: .appBlackColor, size: 14), trailingImage: .Catalogue.chevronRight.image.resized(.squared(16))),
			.init(leadingImg: .customButtonImage(name: .lockClosed)?.roundedImage(),title: "Log Out".styled(font: .medium, color: .appBlackColor, size: 14), trailingImage: .Catalogue.chevronRight.image.resized(.squared(16)))
		]
		return .init(title: "Preferences", rows: buttons.map { TableRow<CustomInfoButtonCell>($0) })
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
