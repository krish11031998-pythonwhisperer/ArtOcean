//
//  NFTDetailViewModel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 20/08/2022.
//

import Foundation
import UIKit

extension Attribute {
	
	var attributeBlob: UIView {
		let trait = trait_type ?? ""
		let value = Value ?? ""
		
		let traitLabel = trait.styled(font: .medium, color: .appPurpleColor, size: 14)
		let valueLabel = value.styled(font: .bold, color: .appPurpleColor, size: 14)
		let insets: UIEdgeInsets = .init(top: 5, left: 12, bottom: 6, right: 12)
		let label = (traitLabel + NSAttributedString(" : ") + valueLabel)
					.label()
		label.textAlignment = .center
		
		return label.marginedBorderedCard(edge: insets, backgroundColor: .appPurple50Color.withAlphaComponent(0.5), cornerRadius: 10)
	}
	
}
