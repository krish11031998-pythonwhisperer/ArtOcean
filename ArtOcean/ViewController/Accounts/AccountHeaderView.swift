//
//  AccountHeaderView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 02/06/2022.
//

import Foundation
import UIKit

class AccountHeaderView: UIView {
    
    private var handler:(() -> Void)? = nil
    private var imgHeightConstraint:NSLayoutConstraint? = nil
    private var imgTopAnchor:NSLayoutConstraint? = nil
    private var height:CGFloat = .zero
	private var headerHeight: CGFloat = .zero
	private var currentUser: User? { UserStorage.selectedUser }
	
    private lazy var headerImageView: CustomImageView = {
        let image = CustomImageView(cornerRadius: 0, maskedCorners: nil)
        return image
    }()
    
	private lazy var backButton: CustomImageButton = {
		let button: CustomImageButton = .backButton { [weak self] in
			self?.handler?()
		}
		return button
	}()
	
	private lazy var stackView: UIStackView = {
		let stack: UIStackView = .init(arrangedSubviews: [stretchyHeader, userHeader])
		stack.alignment = .center
		stack.spacing = 12
		stack.axis = .vertical
		return stack
	}()
	
	private lazy var stretchyHeader: StreachyHeaderView = { .init(height: headerHeight, innerView: headerImageView) }()
	
	private lazy var userProfileImage: UIImageView = {
		let imageView = UIImageView()
		imageView.cornerRadius = 20
		imageView.clipsToBounds = true
		imageView.image = .loadingBackgroundImage
		return imageView
	}()
	
	private var nameUsernamelabel: HeaderCaptionLabel = { .init() }()
	
	private lazy var userHeader: UIStackView = {
		let stack: UIStackView = .HStack(views: [userProfileImage, nameUsernamelabel], spacing: 12, aligmment: .center)
		userProfileImage.setAspectRatio(1)
		return stack
	}()
	
	private lazy var artTitleLabel: UILabel = { .init() }()
	
	private var gradientView: UIView = { .init() }()
    
	private var viewSize: CGSize { .init(width: .totalWidth, height: height) }
	
	init(height:CGFloat = 200, headerHeight: CGFloat = 180, handler:@escaping (() -> Void)) {
		super.init(frame: .init(origin: .zero, size: .init(width: .totalWidth, height: height)))
		self.height = height
		self.headerHeight = headerHeight
        self.handler = handler
		setupViews()
		setupLayout()
		buildUI()
    }
    
    required init?(coder: NSCoder) {
		super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
	func setupViews(){
		addSubview(stackView)
		addSubview(backButton)
	}
	
	func buildUI(){
		UIImage.loadImage(url: .testBackdropImage, for: headerImageView, at: \.image)
		UIImage.loadImage(url: .testProfileImage, for: userProfileImage, at: \.image)
		nameUsernamelabel.configureLabel(title: currentUser?.name?.heading3(), subTitle: currentUser?.username?.body1Medium())
	}
    
    func setupLayout(){
		setConstraintsToChild(stackView, edgeInsets: .zero)
		setFrameLayout(childView: backButton, alignment: .topLeading, paddingFactor: .init(top: 40, left: 16, bottom: 0, right: 0))
		setFrameConstraints(size: .init(width: .totalWidth, height: height))
		stackView.setWidthForChildWithPadding(userHeader, paddingFactor: 2)
    }
    
	public func viewAnimationWithScroll(_ scrollView:UIScrollView){
		guard scrollView.contentOffset.y < 0  else { return }
		stretchyHeader.stretchOnScroll(scrollView)
		let alpha: CGFloat = 1 - (0...(100)).precent(abs(scrollView.contentOffset.y)).clamp(1)
		gradientView.alpha = alpha
		backButton.alpha = alpha
	}
}
