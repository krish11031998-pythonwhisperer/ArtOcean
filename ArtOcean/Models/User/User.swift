//
//  User.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 03/06/2022.
//

import Foundation
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
	
	init(_ user: User) {
		self.init(
			title: user.name?.body2Medium(),
			subTitle: user.username?.body3Medium(),
			infoTitle: (user.profit?.toString() ?? "" + NSAttributedString(string: "ETH")).body2Medium(),
			infoSubTitle: (user.profit?.toString() ?? "0").body3Medium(),
			leadingImageUrl: user.image,
			style: .circle(.squared(40)),
			imgSize: .squared(40)) {
				print("(DEBUG) Clicked on the user")
			}
	}
}

extension User {
	
	var row: CellProvider { TableRow<CustomInfoButtonCell>(.init(self)) }
	
	static func decodeFromItem(_ item: Item) -> User? {
		switch item {
		case .user(let user):
			return user
		default:
			return nil
		}
	}
}
