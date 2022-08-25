//
//  RedesignAccountViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 22/08/2022.
//

import Foundation
import UIKit

class NewAccountViewController: UIViewController {
	
	//MARK: -  Properties
	
	private lazy var tableView: UITableView = { .init() }()
	private lazy var tableHeaderView: AccountHeaderView = {
		return AccountHeaderView(height: 300, handler: { [weak self] in
			self?.navigationController?.popViewController(animated: true)
		})
	}()
	private var observer: NSKeyValueObservation?
	
	//MARK: - Constructors
	
	//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideNavBar()
//		tableView.backgroundColor = .appGreenColor
		setupUI()
		observer = tableView.observe(\.contentOffset, changeHandler: { [weak self] tableView, _ in self?.tableHeaderView.viewAnimationWithScroll(tableView)})
	}

	//MARK: - Protected Methods
	
	private func setupUI() {
		view.addViewAndSetConstraints(tableView, edgeInsets: .zero)
		tableView.contentInsetAdjustmentBehavior = .never
		tableView.tableHeaderView = tableHeaderView
	}
	
	
}
