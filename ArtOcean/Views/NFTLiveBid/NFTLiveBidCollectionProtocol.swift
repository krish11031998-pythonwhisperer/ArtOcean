//
//  NFTLiveBidCollectionProtocol.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation

protocol NFTLiveBidCollectionDelegate{
    func viewAll(allArt:[NFTModel])
    func viewNFT(art:NFTModel)
}


protocol NFTLiveBidCellDelegate{
    func viewArt(art:NFTModel)
}
