//
//  RedesignAccountViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 22/08/2022.
//

import Foundation
import UIKit

fileprivate extension Array {
	
	func multiDimension(dim: Int) -> [[Self.Element]] {
		var result: [[Self.Element]] = []
		var row: [Self.Element] = []
		for el in self.enumerated() {
			if el.offset != 0 && el.offset % dim == 0 {
				result.append(row)
				row.removeAll()
			}
			row.append(el.element)
		}
		return result
	}
	
}

class AccountViewController: UIViewController {
	
	//MARK: -  Properties
	
	private lazy var tableView: UITableView = {
		let table: UITableView = .init(frame: .zero, style: .grouped)
		table.separatorStyle = .none
		table.backgroundColor = .white
		table.separatorStyle = .none
		table.separatorInset = .init(vertical: 0, horizontal: 16)
		table.separatorColor = .appGrayColor.withAlphaComponent(0.45)
		return table
	}()
	
	private var segmentControlOrigin: CGPoint = .zero
	
	private lazy var tableHeaderView: AccountHeaderView = {
		return AccountHeaderView(height: 250, headerHeight: 180, handler: { [weak self] in
			self?.navigationController?.popViewController(animated: true)
		})
	}()
	
	private var observer: NSKeyValueObservation?
	
	private lazy var segmentedControl: UIView = {
		let slider = SliderSelector(tabs: [NFTArtOfferSection.selectorItem, NFTArtSection.selectorItem].compactMap {$0})
		return slider.embedInView(edges: .init(top: 20, left: 10, bottom: 10, right: 10))
	}()
	
	//MARK: - Constructors
	
	//MARK: - Overriden Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideNavBar()
		setupUI()
		observer = tableView.observe(\.contentOffset, changeHandler: { [weak self] tableView, _ in self?.updateOnScroll(tableView)})
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		showNavBar()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		if segmentControlOrigin == .zero {
			segmentControlOrigin = segmentedControl.frame.origin
		}
	}

	//MARK: - Protected Methods
	
	private func buildDataSource() -> TableViewDataSource {
		.init(section: [offers].compactMap { $0 })
	}
	
	private var offers: TableSection? {
		guard let items = NFTArtOfferSection.items else { return nil }
		let stackedCells: [UIView] = items.compactMap { NFTArtOffer.decodeFromItem($0) }.map {
			let button = CustomInfoButton()
			button.updateUIButton(.init($0, withArtImage: true))
			return button
		}
		return .init(headerView: segmentedControl, rows: stackedCells.compactMap { $0.TableRowBuilder(edges: .init(vertical: 20, horizontal: 16)) })
	}
	
	private func setupUI() {
		view.addSubview(tableView)
//		view.setSafeAreaConstraintsToChild(tableView, edgeInsets: .zero)
		setConstraintsWithSafeAreaBottom()
		tableView.contentInsetAdjustmentBehavior = .never
		tableView.tableHeaderView = tableHeaderView
		tableView.reload(with: buildDataSource())
	}
	
	private func setConstraintsWithSafeAreaBottom() {
		let constraints = [
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		]
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.removeSimilarConstraints(constraints)
		view.addConstraints(constraints)
	}
	
	private func updateOnScroll(_ scrollView: UIScrollView) {
		tableHeaderView.viewAnimationWithScroll(scrollView)
	}
}
