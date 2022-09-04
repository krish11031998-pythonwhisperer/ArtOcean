//
//  UITableView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 02/09/2022.
//

import Foundation
import UIKit

extension UITableView {
	
	func setHeaderView(_ view: UIView) {
		tableHeaderView = view
		tableHeaderView?.frame = view.compressedFittingSize.frame
	}
}
