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

protocol ConfigurableStyling {
	associatedtype Model
	func configureView(with model:Model)
	static var insetPadding: UIEdgeInsets { get }
	static var cornerRadius: CGFloat { get }
	func prepareCellForReuse()
}

extension ConfigurableStyling {
	static var insetPadding: UIEdgeInsets { .zero }
	static var cornerRadius: CGFloat { .zero }
}

typealias InnerConfigurableView = UIView & ConfigurableStyling


typealias ConfigurableCell = UITableViewCell & Configurable


//MARK: -  CellProvider
protocol CellProvider{
	var cellModel: Any { get }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath)
	func didSelect(_ tableView: UITableView, indexPath: IndexPath)
}



//MARK: - ActionProvider
typealias Callback = () -> Void
protocol ActionProvider{
	var action:Callback? { get }
	var update: Bool { get }
}

extension ActionProvider {
	var update: Bool { false }
}

//MARK: -  TableRow
class TableRow<Cell : ConfigurableCell> : CellProvider{

	var model : Cell.Model
	
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
	
	func didSelect(_ tableView: UITableView, indexPath: IndexPath) {
		guard let model = model as? ActionProvider else {
			return
		}
		
		if model.update {
			tableView.deselectRow(at: indexPath, animated: false)
			tableView.beginUpdates()
			model.action?()
			tableView.endUpdates()
		}else {
			let cell = tableView.cellForRow(at: indexPath)
			cell?.animate(.scaleInOut(duration: 0.1), completion: {
				model.action?()
			})
		}
	}
    
}
