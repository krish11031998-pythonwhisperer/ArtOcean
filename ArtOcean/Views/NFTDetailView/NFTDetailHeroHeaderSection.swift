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
	
	private var height:CGFloat
	private var imageScale:CGFloat = 1
	private let originalImageWidth:CGFloat = UIScreen.main.bounds.width - 32
	public let originalImageHeight:CGFloat = 230
	private let imageViewTopPadding:CGFloat = 132
	private var imageWidthConstraint:NSLayoutConstraint? = nil
	private var imageHeightConstraint:NSLayoutConstraint? = nil
	private var topAnchorPaddingConstraint:NSLayoutConstraint? = nil
	private var nftArt:NFTModel
    
    //MARK: - Views
    private lazy var backgroundImageView:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 0)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private lazy var imageView:CustomImageView = .init(cornerRadius: 16)

    //MARK: - View LifeCycle and Init
    
    init(nft:NFTModel,height:CGFloat){
		self.height = height
		nftArt = nft
		super.init(frame:.init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: height)))
        setupViews()
        setupLayout()
		isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    
    private func setupViews(){
		addSubview(backdropImage)
		addSubview(imageView)
		imageView.updateImageView(url: nftArt.metadata?.image)
    }
    
    public func updateImages(url:String){
        backgroundImageView.updateImageView(url: url)
        imageView.updateImageView(url: url)
    }
    
    func animateHeaderView(_ scrollView:UIScrollView){
		animateImageView(scrollView)
    }
	
	private lazy var backdropImage: UIView = {
		let image:CustomImageView = .init(cornerRadius: 0)
		image.updateImageView(url: nftArt.metadata?.image)
		image.setFrameConstraints(width: UIScreen.main.bounds.width, height: 200)
		image.blurGradientBackDrop(size: .init(width: UIScreen.main.bounds.width, height: 200))
		return image
	}()
	
    public func animateImageView(_ scrollView:UIScrollView){
		let point = scrollView.contentOffset.y
		let totalHeight = height
        let maxPoint = totalHeight
		let minPoint = totalHeight * 0.5
		let scaleFactor =  -(point - minPoint)/(maxPoint - minPoint)
		imageScale = scaleFactor > 1.05 ? 1.05 : scaleFactor < 0 ? 0 : scaleFactor
		UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) {
			self.imageView.transform = .init(scaleX: self.imageScale, y: self.imageScale)
			self.topAnchorPaddingConstraint?.constant = scaleFactor * self.imageViewTopPadding
			self.imageView.alpha = self.imageScale < 0.35 ? 0 : self.imageScale > 0.85 ? 1 : self.imageScale
			self.backdropImage.alpha = self.imageScale
		}.startAnimation()
    }
    
    private func setupLayout(){
		imageView.setFrameConstraints(size: .init(width: originalImageWidth, height: originalImageHeight))
		setFrameLayout(childView: imageView, alignment: .centerX, paddingFactor: .zero)
		
		topAnchorPaddingConstraint = imageView.topAnchor.constraint(equalTo: topAnchor,constant: 132)
		topAnchorPaddingConstraint?.isActive = true
		
    }
	    
    
}
