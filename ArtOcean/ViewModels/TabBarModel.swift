//
//  TabBarModel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

struct styleComponents{
    var name:String
    var icon:String
}


enum Tabs{
    case home
    case search
    case statistics
    case profile
}


extension Tabs{
    func tabStyleComponents() -> styleComponents{
        switch self {
        case .home:
            return .init(name: "Home", icon: "home")
        case .search:
            return .init(name: "Search", icon: "search")
        case .statistics:
            return .init(name: "Statistics", icon: "statistics")
        case .profile:
            return .init(name: "Profile", icon: "profile")
        }
    }
}
