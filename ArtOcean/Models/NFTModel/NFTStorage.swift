//
//  NFTStorage.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 21/08/2022.
//

import Foundation

class NFTStorage: StateStorage {
	
	enum Key: String,CaseIterable {
		case selectedNFTArt
	}
	
	public static var selectedArt: NFTModel? {
		get { Self.shared.getValue(for: Key.selectedNFTArt.rawValue) }
		set { Self.shared.setValue(for: Key.selectedNFTArt.rawValue, value: newValue) }
	}
	
}
