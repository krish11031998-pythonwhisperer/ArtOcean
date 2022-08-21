//
//  UserStorage.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 21/08/2022.
//

import Foundation
import UIKit

class UserStorage: StateStorage {
	
	enum Key: String,CaseIterable {
		case selectedUser
	}
	
	public static var selectedUser: User? {
		get { Self.shared.getValue(for: Key.selectedUser.rawValue) }
		set { Self.shared.setValue(for: Key.selectedUser.rawValue, value: newValue) }
	}
	
	
}
