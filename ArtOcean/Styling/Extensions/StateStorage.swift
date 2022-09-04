//
//  NotificationCenter.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 21/08/2022.
//

import Foundation
import UIKit


class StateStorage {
	
	private var stateStorage: [String:Any] = [:]
	public static var shared: StateStorage = StateStorage()
	
	func setValue<T:Encodable>(for key: String, value: T) { stateStorage[key] = value }
	
	func getValue<T:Decodable>(for key: String) -> T? { stateStorage[key] as? T }
	
	func removeValue(for key: String) { stateStorage[key] = nil }
	
}
