//
//  CustomTableViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 15/06/2022.
//

import Foundation
import UIKit

//MARK: - CustomTableWrapperView

class CustomTableWrapperView<Cell:InnerConfigurableView> : ConfigurableCell {

	typealias Model = Cell.Model

	func configureCell(with model: Cell.Model) {
		backgroundColor = .clear
		let content = Cell()
		removeAllSubViews()
		addViewAndSetConstraints(content, edgeInsets: Cell.insetPadding)
		content.configureView(with: model)
		content.cornerRadius = Cell.cornerRadius
	}
	
	
	override func prepareForReuse() {
		let cell = Cell()
		cell.prepareCellForReuse()
	}
}

//MARK: - CustomCollectionWrapperView

class CustomCollectionWrapperView<Cell: InnerConfigurableView> : ConfigurableCollectionCell {
	
	typealias Model = Cell.Model
	
	func configureCell(with model: Cell.Model) {
		backgroundColor = .clear
		let content = Cell()
		removeAllSubViews()
		addViewAndSetConstraints(content, edgeInsets: Cell.insetPadding)
		content.configureView(with: model)
		content.cornerRadius = Cell.cornerRadius
	}
	
	override func prepareForReuse() {
		let cell = Cell()
		cell.prepareCellForReuse()
	}
}

//MARK: - CustomTableCell

struct CustomTableCellModel: ActionProvider {
	let innerView: UIView
	let edgeInsets: UIEdgeInsets
	let reload: Bool
	var action: Callback?
	
	var update: Bool { reload }
	
	init(innerView: UIView, edgeInsets: UIEdgeInsets, reload: Bool = false, action: Callback? = nil) {
		self.innerView = innerView
		self.edgeInsets = edgeInsets
		self.reload = reload
		self.action = action
	}
}

class CustomTableCell: ConfigurableCell {
	
	func configureCell(with model: CustomTableCellModel) {
		contentView.removeAllSubViews()
		backgroundColor = .surfaceBackground
		isUserInteractionEnabled = model.action != nil
		contentView.addSubview(model.innerView)
		contentView.setConstraintsToChild(model.innerView, edgeInsets: model.edgeInsets, withPriority: UILayoutPriority.needed.rawValue)
		clipsToBounds = true
	}
}

//MARK: - CustomCollectionCell

struct CustomCollectionCellModel: ActionProvider {
	var innerView: UIView
	var edgeInsets: UIEdgeInsets
	var background: UIColor?
	var action: Callback?
}

class CustomCollectionCell: ConfigurableCollectionCell {
	
	func configureCell(with model: CustomCollectionCellModel) {
		contentView.removeAllSubViews()
		backgroundColor = model.background ?? .clear
		isUserInteractionEnabled = model.action != nil
		contentView.addSubview(model.innerView)
		contentView.setConstraintsToChild(model.innerView, edgeInsets: model.edgeInsets)
	}
}
