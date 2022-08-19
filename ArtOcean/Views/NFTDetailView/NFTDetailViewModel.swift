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
		
		let traitLabel = trait.styled(font: .medium, color: .appPurpleColor, size: 15)
		let valueLabel = value.styled(font: .bold, color: .appPurpleColor, size: 15)
		
		let label = (traitLabel + NSAttributedString(" : ") + valueLabel)
					.label()
					.marginedBorderedCard(edge: .init(vertical: 5, horizontal: 12),backgroundColor: .appPurple50Color.withAlphaComponent(0.5), cornerRadius: 10)
	
		return label
	}
	
}
