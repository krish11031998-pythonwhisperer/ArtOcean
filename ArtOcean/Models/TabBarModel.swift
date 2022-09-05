//
//  TabBarModel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

struct TabItemData {
    var name:String
    var icon:String
}


enum Tabs{
    case home
    case search
    case statistics
    case profile
	case add
}


extension Tabs{
    func tabStyleComponents() -> TabItemData{
        switch self {
        case .home:
            return .init(name: "Home", icon: "home")
        case .search:
            return .init(name: "Search", icon: "search")
        case .statistics:
            return .init(name: "Statistics", icon: "statistics")
        case .profile:
            return .init(name: "Profile", icon: "profile")
		default:
			return .init(name: "", icon: "")
        }
    }
}
