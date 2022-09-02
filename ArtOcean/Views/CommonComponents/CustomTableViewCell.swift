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
	var innerView: UIView
	var edgeInsets: UIEdgeInsets
	var action: Callback?
}

class CustomTableCell: ConfigurableCell {
	
	func configureCell(with model: CustomTableCellModel) {
		
		contentView.removeAllSubViews()
		backgroundColor = .surfaceBackground
		isUserInteractionEnabled = model.action != nil
		contentView.addSubview(model.innerView)
		contentView.setConstraintsToChild(model.innerView, edgeInsets: model.edgeInsets)
	}
}
