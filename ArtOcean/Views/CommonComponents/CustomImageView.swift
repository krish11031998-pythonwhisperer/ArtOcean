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
    private var colors:[UIColor] = []
    private var named:String? = nil
    private var url:String? = nil
    init(url:String? = nil,named:String? = nil,cornerRadius:CGFloat,maskedCorners:CACornerMask? = nil){
        super.init(frame: .zero)
        self.named = named
        self.url = url
        self.layer.cornerRadius = cornerRadius
        if let safeMaskedCorner = maskedCorners{
            self.layer.maskedCorners = safeMaskedCorner
        }
        self.setupImageView()
    }
    
    init(cornerRadius:CGFloat,maskedCorners:CACornerMask? = nil,gradientColors:[UIColor]){
        super.init(frame: .zero)
        self.colors = gradientColors
        self.layer.cornerRadius = cornerRadius
        if let safeMaskedCorner = maskedCorners{
            self.layer.maskedCorners = safeMaskedCorner
        }
        self.setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let safeGradient = self.gradient{
            safeGradient.frame = self.frame
        }
    }
    
    private var gradient:CAGradientLayer? = nil
    
    private func setupImageView(){
        if let safeNamed = self.named{
            self.image = .init(named: safeNamed)
        }else{
            self.image = .init(named: "placeHolder")
        }
        
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFill
        if !self.colors.isEmpty{
            self.gradient = CAGradientLayer()
            self.gradient!.colors = self.colors.compactMap({$0.cgColor})
            self.layer.addSublayer(self.gradient!)
        }
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
