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
	var title:String?
	var rows:[CellProvider]

	init(
		headerView:UIView? = nil,
		title:String?,
		rows:[CellProvider]
	){
		self.title = title
		self.headerView = headerView
		self.rows = rows
	}

	convenience init(headerView:UIView?,rows:[CellProvider]){
		self.init(headerView: headerView,title:nil, rows: rows)
	}
	
	convenience init(title:String?,rows:[CellProvider]){
		self.init(headerView: nil, title: title, rows: rows)
	}
	
	convenience init(rows:[CellProvider]) {
		self.init(headerView: nil, title: nil, rows: rows)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { rows[indexPath.row].tableView(tableView, cellForRowAt: indexPath) }
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let customHeaderView = headerView{
			return customHeaderView
		}else if let safeTitle = title {
			let header = ContainerHeaderView(title: safeTitle)
			return header
		}else{
			return nil
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let row = rows[indexPath.row]
		row.didSelect(tableView)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }
	
}

//MARK: - CollectionSection
class CollectionSection:TableSectionDataSource {

	let columns:[CellProviderColumn]
	var layout:UICollectionViewFlowLayout
	let headerView:UIView?
	let padding:Bool
	
	init(
		headerView:UIView?,
		columns:[CellProviderColumn],
		layout:UICollectionViewFlowLayout,
		padding:Bool
	) {
		self.headerView = headerView
		self.columns = columns
		self.layout = layout
		self.padding = padding
	}
	
	convenience init (headerView:UIView?,columns:[CellProviderColumn],padding:Bool = false){
		self.init(headerView: headerView, columns: columns, layout: .standardFlow,padding:padding)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = CollectionViewTableCell(withPadding: padding)
		cell.configureCell(with: .init(columns: columns, layout: layout))
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

////MARK: - TableSection
//class TableSection{
//
//	let headerView:UIView?
//	let title:String?
//	let rows:[CellProvider]
//	let axis:UIAxis
//
//	init(headerView:UIView? = nil,title:String? = nil,rows:[CellProvider],axis:UIAxis = .vertical){
//		self.headerView = headerView
//		self.rows = rows
//		self.axis = axis
//		self.title = title
//	}
//
//	convenience init(headerView:UIView? = nil,columns:[CellProvider]){
//		self.init(headerView: headerView, rows: columns, axis: .horizontal)
//	}
//
//	convenience init(title:String? = nil,rows:[CellProvider]){
//		self.init(title: title, rows: rows, axis: .vertical)
//	}
//
//}
//
//
////MARK: -  TableSource
//class TableViewDataSource:NSObject{
//
//	var section:[TableSection]
//
//	init(section:[TableSection]){
//		self.section = section
//	}
//
//}
//
//extension TableViewDataSource:UITableViewDataSource{
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.section[section].rows.count }
//
//	func numberOfSections(in tableView: UITableView) -> Int { self.section.count }
//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		section[indexPath.section].rows[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
//	}
//
//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////		if let customHeaderView = self.section[section].headerView{
////			return customHeaderView
////		}else if let safeTitle = self.section[section].title {
////			let header = ContainerHeaderView(title: safeTitle)
////			return header
////		}else{
////			return nil
////		}
////		return nil
//	}
//
//	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//		return nil
//	}
//}
//
//
//extension TableViewDataSource:UITableViewDelegate{
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		let row = section[indexPath.section].rows[indexPath.row]
//		row.didSelect(tableView)
//	}
//
//}
