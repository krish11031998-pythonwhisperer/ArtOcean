//
//  CustomAnimatedImage.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 12/06/2022.
//

import Foundation
import UIKit
import SDWebImage

class CustomAnimatedImage:SDAnimatedImageView{
    
    init(){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateAnimatedImageView(url:String){
        guard let safeURL = URL(string: url) else {return}
        if let imageData = DataCache.shared[safeURL]{
            print("(DEBUG) Loaded the animated Image from cache")
            if let safeAnimatedImage = SDAnimatedImage(data: imageData){
                image = safeAnimatedImage
            }
        }
        let dataSession = URLSession.shared.dataTask(with: safeURL) { data, resp, err in
            guard let safeData = data else {
                if let errMessage = err?.localizedDescription{
                    print("(Error) Err : ",errMessage)
                }
                return
            }
            
            DataCache.shared[safeURL] = safeData
        
            if let animatedImage = SDAnimatedImage(data: safeData){
                DispatchQueue.main.async { [weak self] in
                    self?.image = animatedImage
                }
            }
        }
        dataSession.resume()
    }
    
    
}
