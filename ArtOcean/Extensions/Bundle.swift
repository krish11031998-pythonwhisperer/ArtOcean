//
//  Bundle.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 04/06/2022.
//

import Foundation

extension Bundle{
    
    enum DecodeFileError:String,Error{
        case noSafeURL = "No File found in the Bundle"
        case noData = "No Data parsed from the file"
        case parseData = "Can parse the model from the data"
    }
    
    func decodable<T:Decodable>(_ type:T.Type,for name:String,completion: @escaping (Result<T,Bundle.DecodeFileError>) -> Void){
        guard let safeUrl = self.url(forResource: name, withExtension: nil) else{
            completion(.failure(.noSafeURL))
            return
        }
        
        guard let safeData = try? Data(contentsOf: safeUrl) else{
            completion(.failure(.noData))
            return
        }
        
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(type.self, from: safeData) else {
            completion(.failure(.parseData))
            return
        }
        
        completion(.success(result))
    }
}
