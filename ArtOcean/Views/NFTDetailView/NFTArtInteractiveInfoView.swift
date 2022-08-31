//
//  NFTArtInteractiveInfoView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit

class NFTArtInteractiveInfoView:UIView{
    
    //MARK: - Views
    private lazy var timeLeftLabel:UIView = {
        let label = CustomLabel(text: "3h 12m 36s left",weight: .medium, color: .appPurpleColor, numOfLines: 3)
        label.textAlignment = .center
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .appPurple50Color
        view.clipsToBounds = true
		
		view.addViewAndSetConstraints(label, edgeInsets: .init(vertical: 4, horizontal: 12))
        
        return view
    }()
    
    private let shareButton:CustomImageButton = {
		.init(name: .share) {
			print("(DEBUG) heart pressed")
		}
	}()
    
	private let loveButton:CustomImageButton = {
		.init(name: .heartOutline) {
			print("(DEBUG) heart pressed")
		}
	}()
    
	private lazy var stackView: UIStackView = {
		let stack: UIStackView = .init(arrangedSubviews: [timeLeftLabel,.spacer(),shareButton,loveButton])
		stack.spacing = 16
		
		return stack
	}()
    
	override init(frame: CGRect){
        super.init(frame: .zero)
		addViewAndSetConstraints(stackView, edgeInsets: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
