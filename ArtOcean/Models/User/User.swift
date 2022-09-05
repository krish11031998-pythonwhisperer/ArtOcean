//
//  User.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 03/06/2022.
//

import Foundation
import UIKit
struct User:Codable,Hashable{
    var name:String?
    var username:String?
    var worthValue:Float?
    var worthCurrency:String?
    var image:String?
    var profit:Float?
    var items:Int?
    var owners:Int?
    var floor_price:Float?
    var traded:Float?
}


struct UserResponse:Codable{
    var users:[User]?
}

let testUser:[User] = {
    var resultUsers:[User] = []
    Bundle.main.decodable(UserResponse.self, for: "user.json", completion: { result in
        switch result{
        case .success(let userResp):
            if let users = userResp.users{
                resultUsers = users
            }
        case .failure(let err):
            print("(DEBUG) err : ",err.rawValue)
        }
        
    })
    
    return resultUsers
}()


extension CustomInfoButtonModel {
	
	init(_ user: User, edges: UIEdgeInsets = .init(vertical: 10, horizontal: 16)) {
		self.init(
			title: user.name?.body2Medium(),
			subTitle: user.username?.body3Medium(),
			infoTitle: (user.profit?.toString() ?? "" + " ETH").body2Medium(),
			infoSubTitle: (user.profit?.toString() ?? "0").body3Medium(),
			leadingImageUrl: user.image,
			style: .circle(.squared(40)),
			leadingImgSize: .squared(40),
			edges: edges) {
				UserStorage.selectedUser = user
				NotificationCenter.default.post(name: .showAccount, object: nil)
			}
	}
}

extension User {
	
	var row: CellProvider { TableRow<CustomInfoButtonCell>(.init(self)) }
	var collectionCell: CollectionCellProvider { CollectionColumn<CustomInfoButtonCollectionCell>(.init(self)) }
	
	static func decodeFromItem(_ item: Item) -> User? {
		switch item {
		case .user(let user):
			return user
		default:
			return nil
		}
	}
}
