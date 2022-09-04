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
		
		let traitLabel = trait.body2Regular(color: .purple600)
		let valueLabel = value.body2Medium(color: .purple600)
		let insets: UIEdgeInsets = .init(top: 5, left: 12, bottom: 6, right: 12)
		let label = UILabel()
		(traitLabel.attributedString + " : ".styled(font: .regular, color: .purple600, size: 14).attributedString + valueLabel.attributedString).renderInto(target: label)
					
		label.textAlignment = .center
		
		return label.marginedBorderedCard(edge: insets, borderColor: .purple500, backgroundColor: .purple50, cornerRadius: 10)
	}
	
}
