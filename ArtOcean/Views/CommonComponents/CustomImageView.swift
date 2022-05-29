//
//  CustomImageView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 29/05/2022.
//

import Foundation
import UIKit


class CustomImageView:UIImageView{
        
    private let imageDownloader:ImageDownloader = ImageDownloader()
    
    init(cornerRadius:CGFloat,maskedCorners:CACornerMask? = nil){
        super.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        if let safeMaskedCorner = maskedCorners{
            self.layer.maskedCorners = safeMaskedCorner
        }
        self.image = .init(named: "placeHolder")
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateImageView(url:String?){
        guard let safeURL = url else {return}
        self.imageDownloader.fetchImage(urlStr: safeURL) { [weak self] result in
            switch result{
                case .success(let image):
                    if let safeImageView = self{
                        DispatchQueue.main.async {
                            UIView.transition(with: safeImageView,duration: 1.0, options: [.curveEaseOut, .transitionCrossDissolve]) {
                                    self?.image = image
                                }
                        }
                    }
                case .failure(let err):
                    print("(DEBUG) There was a error while fetching the image : ",err.localizedDescription)
            }
        }
    }
}
