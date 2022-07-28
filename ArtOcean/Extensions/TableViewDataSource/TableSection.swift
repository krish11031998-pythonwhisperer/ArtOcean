//
//  TableSection.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 29/06/2022.
//

import Foundation
import UIKit

//MARK: - TableSection

typealias TableSectionDataSource = NSObject & UITableViewDelegate & UITableViewDataSource

class TableSection:TableSectionDataSource{
	
	var headerView:UIView?
	var rows:[CellProvider]

    init(
		headerView:UIView? = nil,
		rows:[CellProvider]
	){
		self.headerView = headerView
		self.rows = rows
	}

	convenience init (title:String, rows:[CellProvider]) {
		let headerView = ContainerHeaderView(title: title)
		self.init(headerView: headerView, rows: rows)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { rows[indexPath.row].tableView(tableView, cellForRowAt: indexPath) }
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { headerView }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let row = rows[indexPath.row]
		row.didSelect(tableView)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }
	
}

//MARK: - CollectionSection
class TableCollectionSection:TableSectionDataSource {

	let columns:[CellProviderColumn]
	let layout:UICollectionViewFlowLayout
	let headerView:UIView?
	let size:CGSize
	
	init(
		headerView:UIView?,
		columns:[CellProviderColumn],
		layout:UICollectionViewFlowLayout = .standardFlow,
		size:CGSize = .zero
	) {
		self.headerView = headerView
		self.columns = columns
		self.layout = layout
		self.size = size
	}
	

	convenience init (headerView:UIView?, columns:[CellProviderColumn],layout:UICollectionViewFlowLayout, height: CGFloat) {
		self.init(headerView: headerView, columns: columns, layout:layout, size:.init(width: .totalWidth, height: height))
	}

	convenience init (title:String,columns:[CellProviderColumn],layout:UICollectionViewFlowLayout,height:CGFloat) {
		let headerView = ContainerHeaderView(title: title)
		self.init(headerView:headerView, columns: columns, layout: layout, height: height)
	}
	
	convenience init (
		title:String,
		rightTitle:String,
		columns:[CellProviderColumn],
		layout:UICollectionViewFlowLayout,
		height:CGFloat = .zero,
		handler:(() -> Void)? = nil
	) {
		let headerView = ContainerHeaderView(title: title, rightButtonTitle: rightTitle, buttonHandler: handler)
		self.init(headerView:headerView, columns: columns, layout: layout, height: height)
	}
	
	private var collectionDataSource: CollectionDataSource { .init(columns: columns,layout: layout,width: size.width,height: size.height) }

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = CollectionViewTableCell()
		cell.configureCell(with: collectionDataSource)
		cell.backgroundColor = .clear
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { headerView }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
	
}


//MARK: -  TableSource
class TableViewDataSource:NSObject{
	
	var section:[TableSectionDataSource]
	
	init(section:[TableSectionDataSource]){
		self.section = section
	}
	
}

extension TableViewDataSource:UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.section[section].tableView(tableView, numberOfRowsInSection: section)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int { self.section.count }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		section[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		self.section[section].tableView?(tableView, viewForHeaderInSection: section)
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
}


extension TableViewDataSource:UITableViewDelegate{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		section[indexPath.section].tableView?(tableView, didSelectRowAt: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { .zero }

}
