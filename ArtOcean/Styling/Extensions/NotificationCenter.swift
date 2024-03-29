//
//  NotificationCenter.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 21/08/2022.
//

import Foundation
import UIKit

extension Notification.Name {
	
	static let showArt: Notification.Name = .init(rawValue: "showArt")
	static let showAccount: Notification.Name = .init(rawValue: "showAccount")
	static let stickyFooterShown: Notification.Name = .init(rawValue: "stickyFooterShown")
	static let stickyFooterHidden: Notification.Name = .init(rawValue: "stickyFooterHidden")
	
}
