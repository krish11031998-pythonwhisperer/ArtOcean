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

struct TransactionModel:Decodable{
    var type:TranscationType
    var value:Float
    var dayTimes:String
    var artModel:NFTModel?
}


let txns:[TransactionModel] = {
    var art:[TransactionModel] = []
    for i in 0...9{
        var txn:TransactionModel = .init(type: .buy, value: Float.random(in: 0.1...5.0), dayTimes: "\(Int.random(in: 1...4))")
        switch i%4{
        case 0:
            txn.type = .send
        case 1:
            txn.type = .receive
        case 2:
            txn.type = .buy
            txn.artModel = .testsArtData?.shuffled().first
        case 3:
            txn.type = .sell
            txn.artModel = .testsArtData?.shuffled().first
        default:
            break
        }
        art.append(txn)
    }
    return art
}()
