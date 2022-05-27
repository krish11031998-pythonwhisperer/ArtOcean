//
//  AlchemyAPI.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import UIKit
import Foundation

enum AlchemyAPIEndpoints:String{
    case getNFts = "getNFTs"
}

class AlchemyAPIConstants{
    static let baseURL:String = "https://eth-mainnet.alchemyapi.io/v2"
    static let apikey:String = "N2GWQaof7Kj3sVgbOI-uhfaOCNMbIasl"
}


class AlchemyAPI{
    
    init(){}
    
    static var shared:AlchemyAPI = .init()
    
    func URLBuilder(path:String,params:[String:String]) -> URL?{
        var uC = URLComponents(string: AlchemyAPIConstants.baseURL)
        uC?.path += "/\(AlchemyAPIConstants.apikey)/\(path)"
        uC?.queryItems = params.map({URLQueryItem(name: $0, value: $1)})
        return uC?.url
    }
    
    
    func dataFetchExecutor(url:URL,completion:@escaping ((Result<Data,DataError>) -> Void)){
        if let cacheDataForURL = DataCache.shared[url]{
            completion(.success(cacheDataForURL))
        }else{
            print("(DEBUG) Fetching New Data : \(url)")
            let session = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let safeResponse = response as? HTTPURLResponse else{
                    print("(Error) err@dataFetchExecutor no statusCode : ",DataError.noResponse.localizedDescription)
                    completion(.failure(.noResponse))
                    return
                }
                
                if safeResponse.statusCode > 400 && safeResponse.statusCode < 500{
                    print("(Error) err@dataFetchExecutor statusCode invalid : ",DataError.responseStatusInvalid.localizedDescription)
                    completion(.failure(.responseStatusInvalid))
                    return
                }
                
                guard let safeData = data else {
                    if let error = error {
                        print("(Error) There was an error : ",error.localizedDescription)
                        completion(.failure(.noData))
                    }
                    return
                }
                
                DataCache.shared[url] = safeData
                
                completion(.success(safeData))
            }
            
            session.resume()

        }
    }
    
    func getNFTs(address:String,completion: @escaping (Result<[NFTModel],DataError>) -> Void){
        guard let safeURL = self.URLBuilder(path: AlchemyAPIEndpoints.getNFts.rawValue, params: ["owner":address]) else {
            completion(.failure(.invalidURL))
            return
        }
        
        self.dataFetchExecutor(url: safeURL) { result in
            switch result{
            case .success(let data):
                NFTDataResponse.parseNFTModels(data: data, completion: completion)
            case .failure(let err):
                print("(There was an error !) : ",err.localizedDescription)
                completion(.failure(err))
            }
        }
    }
    
    func getNftsFromFile(fileName:String,completion:@escaping (Result<Array<NFTModel>,DataError>) -> Void){
        guard let safeData = self.readJsonFile(forName: fileName) else {
            completion(.failure(.noData))
            return
        }
        
        NFTDataResponse.parseNFTModels(data: safeData, completion: completion)
        
    }
    
    func readJsonFile(forName name:String) -> Data?{
        do{
            if let bundlePath = Bundle.main.url(forResource: name, withExtension: "json"){
                let jsonData = try String(contentsOf: bundlePath).data(using: .utf8)
                return jsonData
            }
        }catch{
            print("There was an error : ",error.localizedDescription)
        }
        return nil
    }

    
}
