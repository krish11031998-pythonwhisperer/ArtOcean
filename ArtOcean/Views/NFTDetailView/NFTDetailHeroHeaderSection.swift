//
//  NFTDetailHeroHeaderSection.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit

class NFTHeroHeaderView:UIView{
    
    //MARK: - View Properties
    private var onCloseHandler:(() -> Void)
    private var height:CGFloat
    private var imageScale:CGFloat = 1
	private let originalImageWidth:CGFloat = UIScreen.main.bounds.width - 40
	public let originalImageHeight:CGFloat = UIScreen.main.bounds.height * 0.35
	private var imageWidthConstraint:NSLayoutConstraint? = nil
	private var imageHeightConstraint:NSLayoutConstraint? = nil
	private var heroHeaderHeightConstraint:NSLayoutConstraint? = nil
	private var nftArt:NFTModel
    
    //MARK: - Views
    private lazy var backgroundImageView:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 0)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
	private lazy var heroHeaderView:StreachyHeaderView = StreachyHeaderView(height: height - originalImageHeight * 0.5, innerView: backgroundImageView)
    
    private lazy var imageView:CustomImageView = .init(cornerRadius: 16)
    
    private let leftButton:CustomButton

    
    //MARK: - View LifeCycle and Init
    
    init(nft:NFTModel,height:CGFloat,handler:@escaping (() -> Void)){
        self.leftButton = CustomButton(systemName: "chevron.left", handler: handler, autolayout: true)
        self.height = height
        self.onCloseHandler = handler
		nftArt = nft
		super.init(frame:.init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: height)))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupViews()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        self.addSubview(heroHeaderView)
        self.addSubview(leftButton)
        self.addSubview(imageView)
		guard let img = nftArt.metadata?.image else { return }
		updateImages(url: img)
    }
    
    public func updateImages(url:String){
        backgroundImageView.updateImageView(url: url)
        imageView.updateImageView(url: url)
    }
    
    func animateHeaderView(_ scrollView:UIScrollView) ->  CGFloat{
		let h = heroHeaderView.StretchOnScroll(scrollView)
		UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) {
			self.heroHeaderHeightConstraint?.constant = h
		}.startAnimation()
        return animateImageView(scrollView)
    }
	
    public func animateImageView(_ scrollView:UIScrollView) -> CGFloat{
		let point = scrollView.contentOffset.y
		let totalHeight = height
        let maxPoint = totalHeight
		let minPoint = totalHeight * 0.5
		let scaleFactor =  -(point - minPoint)/(maxPoint - minPoint)
		imageScale = scaleFactor > 1 ? 1 : scaleFactor < 0 ? 0 : scaleFactor
		UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) {
			let scale = self.imageScale
			self.imageWidthConstraint?.constant = scale * self.originalImageWidth
			self.imageHeightConstraint?.constant = scale * self.originalImageHeight
			self.heroHeaderView.alpha = scale
		}.startAnimation()

		
		return originalImageHeight * 0.5 * imageScale + height
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
			heroHeaderView.topAnchor.constraint(equalTo: topAnchor),
			heroHeaderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
			
            leftButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 3),
            leftButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 5),
			
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: heroHeaderView.bottomAnchor)
        ])
		
		heroHeaderHeightConstraint = heroHeaderView.heightAnchor.constraint(equalToConstant: height - 132)
		heroHeaderHeightConstraint?.isActive = true
		
		imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: originalImageWidth)
		imageWidthConstraint?.isActive = true
		imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: originalImageHeight)
		imageHeightConstraint?.isActive = true
    }
	    
    
}
