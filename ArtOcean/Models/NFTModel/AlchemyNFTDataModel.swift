//
//  AlchemyNFTDataModel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import Foundation

struct NFTDataResponse:Decodable{
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
struct NFTModel:Codable,Hashable{
    let contract: Contract?
    let id: ID?
    let balance: String?
    let title: String?
    let description: String?
    let metadata: Metadata?
    
    var Description:String{
        return metadata?.description ?? "Space the domain of settings and surroundings of events, characters, and objects in literary narrative, along with other domains like story, character, time and ideology, constitutes a fictional universe."
    }
    
    var Title:String{
        if let safeTitle = self.title,safeTitle != ""{
            return safeTitle
        }else{
            return "XXXXX"
        }
    }
    
    static var testsArtData:[NFTModel]? = {
        var results:[NFTModel]? = nil
        Bundle.main.decodable(NFTDataResponse.self, for: "nft.json") { result in
            switch result{
            case .success(let nftResp):
                guard let nfts = nftResp.ownedNfts else {return}
                results = Array(nfts.filter({ art in
                    if let image =  art.metadata?.image,!image.contains("ipfs"){
                        return true
                    }else{
                        return false
                    }
                }))
            case .failure(let err):
                print("(Error) err : ",err.localizedDescription)
            }
        }
        return results
    }()
}

// MARK: - Contract
struct Contract:Codable,Hashable{
    let address: String?
}

enum AlchemyError:String,Codable,Hashable {
    case failedToGetTokenURI = "failedToGetTokenURI"
}

// MARK: - ID
struct ID:Codable,Hashable {
    let tokenId: String?
    let tokenMetadata: TokenMetadata?
}

// MARK: - TokenMetadata
struct TokenMetadata:Codable,Hashable{
    let tokenType: String?
}

enum TokenType:String,Codable,Hashable{
    case erc1155 = "erc1155"
    case erc721 = "erc721"
}

// MARK: - TokenURI
struct TokenURI:Codable,Hashable {
    let raw, gateway: String?
}

// MARK: - Metadata
struct Metadata:Codable,Hashable {
//    var name: String?
    var description: String?
    var image: String?
    var external_url: String?
    var compiler: String?
    let attributes: [Attribute]?
//    let dna: String?
//    let imageDetails: ImageDetails?
//    let animationDetails: AnimationDetails?
//    let imageURL: String?
//    let internalReferenceID, createdBy, internalCodeNumber: String?
//    let animation: String?
//    let title: String?
//    let properties: [Property]?
    
	var Attributes:[Attribute]{
		attributes?.compactMap{ $0 }.filter{ $0.trait_type != nil && ($0.str_value != nil || $0.int_value != nil) } ?? []
	}
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
struct Attribute:Codable,Hashable{
    static func == (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.trait_type == rhs.trait_type
    }
    
    let str_value: String?
    let int_value:Int?
    let trait_type: String?
    let display_type: String?
    
    enum CodingKeys:String,CodingKey{
        case value
        case trait_type
        case display_type
    }

    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        trait_type = try container.decodeIfPresent(String.self, forKey: .trait_type)
        display_type = try container.decodeIfPresent(String.self, forKey: .display_type)
        
        if let safeDisplayType = display_type{
            switch safeDisplayType{
                case "number":
                    do{
                        int_value = try container.decodeIfPresent(Int.self, forKey: .value)
                    }catch{
                        int_value = nil
                    }
                        
                default:
                    int_value = nil
            }
            str_value = nil
        }else{
            int_value = nil
            do{
                str_value = try container.decodeIfPresent(String.self, forKey: .value)
            }catch{
                str_value = nil
            }
        }
    }
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(str_value, forKey: .value)
		try container.encodeIfPresent(int_value, forKey: .value)
		try container.encodeIfPresent(trait_type, forKey: .trait_type)
		try container.encodeIfPresent(display_type, forKey: .display_type)
	}
	
	var Value:String?{
		return str_value != nil ? str_value! : int_value != nil ? "\(int_value!)" : nil
	}
    
}

enum AttributeType:Codable,Hashable{
    case strValue(String)
    case intValue(Int)
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
