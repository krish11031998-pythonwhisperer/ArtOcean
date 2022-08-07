//
//  SliderSelectorView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit

protocol SlideSelectorDelegate{
    func handleSelect(_ id:String)
}

class SliderSelector:UIView{
    
    public var delegate:SlideSelectorDelegate? = nil
    private var hoverViewCenterX:NSLayoutConstraint? = nil
    private var tabs:[String]
    
    init(tabs:[String]){
        self.tabs = tabs
        super.init(frame: .zero)
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor(red: 0.953, green: 0.969, blue: 0.976, alpha: 1)
        self.tabStackBuilder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tabsIndicators:[UIView] = {
        let views:[UIView] = self.tabs.compactMap { tab in
            let view = UIView()
            let imageView = UIImageView(image: .init(named: tab.lowercased()))
            
            view.accessibilityIdentifier = tab
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.tintColor = .appPurpleColor
            imageView.contentMode = .scaleAspectFit
            
            let label = CustomLabel(text: tab.capitalized, size: 14, weight: .regular, color: .appGrayColor, numOfLines: 1, adjustFontSize: true)
            
            label.textAlignment = .left
            
            view.addSubview(imageView)
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -15),
                imageView.widthAnchor.constraint(equalToConstant: 15),
                imageView.heightAnchor.constraint(equalToConstant:15),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 6.5),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
            view.addGestureRecognizer(tapGesture)
            view.layer.cornerRadius = 15
            
            if let firstTab = self.tabs.first, firstTab == tab{
                view.backgroundColor = .white
            }
            return view
        }
        return views
    }()
    
    @objc func tapHandler(_ recognizer:UITapGestureRecognizer){
        guard let id = recognizer.view?.accessibilityIdentifier else {return}
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            recognizer.view?.backgroundColor = .white
            self.tabsIndicators.filter({$0 != recognizer.view!}).forEach({$0.backgroundColor = .clear})
        }.startAnimation()
        
        self.delegate?.handleSelect(id)
        print("(DEBUG) tab : ",id)
    }

    
    func tabStackBuilder(){
        let ratios = Array(repeating: CGFloat(1)/CGFloat(tabsIndicators.count), count: tabsIndicators.count)
        print("(DEBUG) ratios : ",ratios)
        let stackView = UIView.StackBuilder(views: tabsIndicators, ratios: [0.5,0.5], spacing: 10, axis: .horizontal)
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5),
            stackView.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -5)
        ])
    }
    
    
    override var intrinsicContentSize: CGSize{
        return .init(width: UIScreen.main.bounds.width - 20, height: 50)
    }
    
}
