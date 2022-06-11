//
//  TransactionModel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/06/2022.
//

import Foundation

enum TranscationType:String,Codable{
    case buy = "Buy"
    case send = "Send"
    case sell = "Sell"
    case receive = "Receive"
}

struct TransactionModel:Codable{
    var type:TranscationType
    var value:Float
    var dayTimes:String
}


let txns:[TransactionModel] = Array(0...9).compactMap({.init(type: $0%2 == 0 ? .send : .receive, value: Float.random(in: 0.1...5.0), dayTimes: "\(Int.random(in: 1...4))")})
