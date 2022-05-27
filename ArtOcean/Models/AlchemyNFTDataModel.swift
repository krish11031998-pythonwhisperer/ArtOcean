//
//  AlchemyNFTDataModel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import Foundation

struct NFTDataResponse:Codable{
    let ownedNfts: [NFTModel]?
    let pageKey: String?
    let totalCount: Int?
    let blockHash: String?
    
    static func parseNFTModels(data:Data,completion:@escaping (Result<Array<NFTModel>,DataError>) -> Void){
        let decoder = JSONDecoder()
        do{
            let response = try decoder.decode(NFTDataResponse.self, from: data)
            if let ownedNfts = response.ownedNfts {
                completion(.success(ownedNfts))
            }else{
                print("(Error) err : ",DataError.dataMissing.rawValue)
                completion(.failure(.dataMissing))
            }
        }catch{
            print("(Error) err : ",DataError.dataParse.rawValue)
            completion(.failure(.dataParse))
        }
    }
}

// MARK: - OwnedNft
struct NFTModel:Codable{
    let contract: Contract?
    let id: ID?
    let balance: String?
    let title: String?
    let description: String?
//    let tokenUri: TokenURI?
//    let media: [TokenURI]?
    let metadata: Metadata?
//    let timeLastUpdated: String?
}

// MARK: - Contract
struct Contract:Codable{
    let address: String?
}

enum AlchemyError:String,Codable {
    case failedToGetTokenURI = "failedToGetTokenURI"
}

// MARK: - ID
struct ID:Codable {
    let tokenId: String?
    let tokenMetadata: TokenMetadata?
}

// MARK: - TokenMetadata
struct TokenMetadata:Codable{
    let tokenType: String?
}

enum TokenType:String,Codable{
    case erc1155 = "erc1155"
    case erc721 = "erc721"
}

// MARK: - TokenURI
struct TokenURI:Codable {
    let raw, gateway: String?
}

// MARK: - Metadata
struct Metadata:Codable{
//    var name: String?
    var description: String?
    var image: String?
    var external_url: String?
    var compiler: String?
//    let attributes: [Attribute]?
//    let dna: String?
//    let imageDetails: ImageDetails?
//    let animationDetails: AnimationDetails?
//    let imageURL: String?
//    let internalReferenceID, createdBy, internalCodeNumber: String?
//    let animation: String?
//    let title: String?
//    let properties: [Property]?
    
}

// MARK: - AnimationDetails
struct AnimationDetails:Codable{
    let duration: Int
    let sha256: String
    let bytes: Int
    let codecs: [String]
    let format: String
    let width, height: Int
}

// MARK: - Attribute
struct Attribute:Codable{
    let value: Int?
    let trait_type: String?
    let display_type: String?
}

enum DisplayType:Codable{
    case number
}

enum Name:Codable{
    case integer(Int)
    case string(String)
}

// MARK: - ImageDetails
struct ImageDetails:Codable{
    let format: String
    let width: Int
    let sha256: String
    let bytes, height: Int
}

// MARK: - Property
struct Property:Codable{
    let value, traitType: String
}
