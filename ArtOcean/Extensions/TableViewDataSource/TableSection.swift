//
//  TableSection.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 29/06/2022.
//

import Foundation
import UIKit

//MARK: - TableSection
class TableSection{
	
	var headerView:UIView?
	var rows:[CellProvider]
	var axis:UIAxis
	
	init(headerView:UIView? = nil,rows:[CellProvider],axis:UIAxis = .vertical){
		self.headerView = headerView
		self.rows = rows
		self.axis = axis
	}
	
	convenience init(headerView:UIView? = nil,columns:[CellProvider]){
		self.init(headerView: headerView, rows: columns, axis: .horizontal)
	}
	
	
	
}


//MARK: -  TableSource
class TableViewDataSource:NSObject{
	
	var section:[TableSection]
	
	init(section:[TableSection]){
		self.section = section
	}
	
}

extension TableViewDataSource:UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.section[section].rows.count }
	
	func numberOfSections(in tableView: UITableView) -> Int { self.section.count }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		section[indexPath.section].rows[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		self.section[section].headerView
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
}


extension TableViewDataSource:UITableViewDelegate{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let row = section[indexPath.section].rows[indexPath.row]
		row.didSelect(tableView)
	}
	
}
