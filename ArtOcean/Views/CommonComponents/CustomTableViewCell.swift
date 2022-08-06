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
	}
	
	
	override func prepareForReuse() {
		let cell = Cell()
		cell.prepareCellForReuse()
	}
}
