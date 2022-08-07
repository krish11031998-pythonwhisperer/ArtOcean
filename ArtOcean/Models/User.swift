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

