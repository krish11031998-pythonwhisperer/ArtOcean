//
//  CustomImageView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 29/05/2022.
//

import Foundation
import UIKit
import SDWebImage


class CustomImageView:UIImageView{
        
    private let imageDownloader:ImageDownloader = ImageDownloader()
    private var colors:[UIColor] = []
    private var named:String? = nil
    private var url:String? = nil
    init(url:String? = nil,
         named:String? = nil,
         cornerRadius:CGFloat,
         maskedCorners:CACornerMask? = nil){
        super.init(frame: .zero)
        self.named = named
        self.url = url
        self.layer.cornerRadius = cornerRadius
        if let safeMaskedCorner = maskedCorners{
            self.layer.maskedCorners = safeMaskedCorner
        }
        self.setupImageView()
    }
    
    
    init(
        cornerRadius:CGFloat,
        maskedCorners:CACornerMask? = nil,
        gradientColors:[UIColor]
    ){
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
            self.gradientView = UIView()
            self.gradient = CAGradientLayer()
            self.gradient!.colors = self.colors.compactMap({$0.cgColor})
//            self.layer.addSublayer(self.gradient!)
            self.buildGradientView()
        }
    }
    
    private var gradientView:UIView? = nil
    
    
    func buildGradientView(){
        self.gradientView = UIView()
        self.gradientView!.translatesAutoresizingMaskIntoConstraints = false
        self.gradientView!.layer.addSublayer(gradient!)
        
        self.addSubview(self.gradientView!)
        
        NSLayoutConstraint.activate([
            self.gradientView!.topAnchor.constraint(equalTo: self.topAnchor),
            self.gradientView!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.gradientView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.gradientView!.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    public func updateImageView(url:String?){
        guard let safeURL = url else {return}
        self.sd_setImage(with: URL(string: safeURL), placeholderImage: UIImage(named: "placeHolder"))
        
    }
}
