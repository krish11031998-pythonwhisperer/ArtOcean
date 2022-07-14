//
//  TableRow.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 29/06/2022.
//

import Foundation
import UIKit

//MARK: - Configurable Protocol
protocol Configurable{
	associatedtype Model
	func configureCell(with model:Model)
}

typealias ConfigurableCell = UITableViewCell & Configurable


//MARK: -  CellProvider
protocol CellProvider{
	var cellModel: Any { get }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath)
	func didSelect(_ tableView: UITableView)
}



//MARK: - ActionProvider
typealias Callback = () -> Void
protocol ActionProvider{
	var action:Callback? {get}
}


//MARK: -  TableRow
class TableRow<Cell: ConfigurableCell>:CellProvider{

	
	var model:Cell.Model
	
	var cellModel: Any { model }
    
	public init(_ model:Cell.Model){
		self.model = model
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:Cell = tableView.dequeueCell()
		cell.configureCell(with: model)
        cell.selectionStyle = .none
		return cell
	}
	
	func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath) {
		let cell = tableView.dequeueCell() as? Cell
		cell?.configureCell(with: model)
	}
	
	func didSelect(_ tableView: UITableView) {
		guard let model = model as? ActionProvider else {
			return
		}
		model.action?()
	}
    
		
}
