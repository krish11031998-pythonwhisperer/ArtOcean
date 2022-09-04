//
//  UIBarButton.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 31/08/2022.
//

import Foundation
import UIKit

extension UIBarButtonItem {
	
	static func backButton(handler: @escaping () -> Void) -> Self {
		.init(customView: CustomImageButton.backButton(handler: handler))
	}
	
}
