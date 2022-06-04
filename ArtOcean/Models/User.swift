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
    var worthCurrency:Float?
    var image:String?
    var profit:Float?
    var items:Int?
    var owners:Int?
    var floor_price:Float?
    var traded:Float?
}
