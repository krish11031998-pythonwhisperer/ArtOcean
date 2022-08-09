//
//  UIView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import Foundation
import UIKit

//MARK: - UIView Common Extension
extension UIView{

	static func clearView(frame:CGRect = .zero) -> UIView{
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
	public func gradientLayerBuilder(_ color:[CGColor] =  [UIColor.clear.cgColor,UIColor.black.cgColor]) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.colors = color
        return gradient
    }
	
	func addGradientLayer(_ color:[CGColor] =  [UIColor.clear.cgColor,UIColor.black.cgColor]){
		let gradient = gradientLayerBuilder(color)
		layer.addSublayer(gradient)
		gradient.frame = frame
	}
    
    public func bouncyButtonClick(scaleDownTo:CGFloat = 0.95,completion:(() -> Void)? = nil){
        DispatchQueue.main.async {
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                self.transform = CGAffineTransform.init(scaleX: scaleDownTo, y: scaleDownTo)
                self.layoutIfNeeded()
            }.startAnimation()
            
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.layoutIfNeeded()
            }.startAnimation(afterDelay: 0.2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40)) {
            completion?()
        }
    }
    
    public func clearView(){
        self.backgroundColor = .clear
    }
    
    public func imageView(cornerRadius:CGFloat = 10, borderColor:UIColor = .clear,borderWidth:CGFloat = 1,autoLayout:Bool = true,addGradient:Bool = false) -> UIImageView{
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = .init(named: "placeHolder")
        imageView.translatesAutoresizingMaskIntoConstraints = autoLayout
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderColor = borderColor.cgColor
        imageView.layer.borderWidth = borderWidth
        if addGradient{
            let gradient = self.gradientLayerBuilder()
            imageView.layer.addSublayer(gradient)
        }
        return imageView
    }
    
    public func labelBuilder(text:String,size:CGFloat = 13,weight:UIFont.Weight = .semibold,color:UIColor,numOfLines:Int,adjustFontSize:Bool = true) -> UILabel{
        let label = UILabel()
        label.text = text
        switch weight{
            case .black:
                label.font = .init(name: "Satoshi-Black", size: size)
                break
            case .bold:
                label.font = .init(name: "Satoshi-Bold", size: size)
                break
            case .regular:
                label.font = .init(name: "Satoshi-Regular", size: size)
                break
            case .medium:
                label.font = .init(name: "Satoshi-Medium", size: size)
                break
            case .light:
                label.font = .init(name: "Satoshi-Light", size: size)
                break
            default:
                label.font = .systemFont(ofSize: size, weight: .light)
        }
        label.textColor = color
        label.numberOfLines = numOfLines
        label.adjustsFontSizeToFitWidth = adjustFontSize
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func StackBuilder(views:[UIView],ratios:[CGFloat],spacing:CGFloat,axis:NSLayoutConstraint.Axis) -> UIStackView{
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.spacing = spacing
        
        if views.count != ratios.count{
            print("(Error) No. Ratios and Views Count are mismatching !")
        }
        
        for count in 0..<views.count{
            let view = views[count]
            let ratio = ratios[count]
            
            stack.addArrangedSubview(view)
            
			let spacingConstant =  -(count == 0 || count == views.count - 1 ? spacing * 0.5 : spacing)
			
            if axis == .vertical{
                view.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: ratio,constant: spacingConstant).isActive = true
            }else if axis == .horizontal{
                view.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: ratio,constant: spacingConstant).isActive = true
            }
        }
        
        return stack
    }
    
	
	static func StackBuilder(views:[UIView],spacing:CGFloat = 16, axis:NSLayoutConstraint.Axis) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: views)
		stack.axis = axis
		stack.spacing = spacing
		return stack
	}
	
    
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2.5
    }
	
	func removeShadow() {
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = 0
		
	}
	
	static func spacer(width:CGFloat? = nil,height:CGFloat? = nil) -> UIView{
		let view = UIView(frame: .init(origin: .zero, size: .init(width: width ?? 0, height: height ?? 0)))
		view.setFrameConstraints(width: width, height: height)
		return view
	}
		
	var snapshot:UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds)
		let img =  renderer.image { context in
			layer.render(in: context.cgContext)
		}
		return img
	}
		
	var cornerRadius: CGFloat {
		get { layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}
	
	var borderWidth: CGFloat {
		get { layer.borderWidth }
		set { layer.borderWidth = newValue }
	}
	
	var borderColor: UIColor? {
		get { UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
		set { layer.borderColor = newValue?.cgColor }
	}
	
	
	func bordered(cornerRadius: CGFloat = 8, borderWidth: CGFloat = 1, borderColor: UIColor = .black) {
		self.cornerRadius = cornerRadius
		self.borderWidth = borderWidth
		self.borderColor = borderColor
	}
}

//MARK: - UIView Constaint Extension

extension UIView {
	enum Alignment {
		case topLeading
		case top
		case topTrailing
		case leading
		case center
		case centerX
		case centerY
		case trailing
		case bottomLeading
		case bottom
		case bottomTrailing

//		var anchors:[NSLayoutAnchor<AnyObject>] {
//			switch self {
//			case .topLeading :
//				return [topAnchor,leadingAnchor]
//			default:
//				return [centerXAnchor]
//			}
//		}
	}
	
	func removeAllConstraints() { removeConstraints(constraints) }
	
	func addViewAndSetConstraints(_ innerView:UIView?,edgeInsets:UIEdgeInsets) {
		guard let safeInnerView = innerView else { return }
		addSubview(safeInnerView)
		setContraintsToChild(safeInnerView, edgeInsets: edgeInsets)
	}
	
	func setContraintsToChild(_ childView:UIView,edgeInsets:UIEdgeInsets,withPriority: Float = 1000){
		let constraints = [
			childView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgeInsets.left),
			childView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgeInsets.right),
			childView.topAnchor.constraint(equalTo: self.topAnchor, constant: edgeInsets.top),
			childView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -edgeInsets.bottom)
		].map { $0.setPriority(priority: withPriority) }
		
		removeConstraints(constraints)
		childView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints)
	}
	
	func setHorizontalConstraintsToChild(_ childView: UIView, edgeInsets: UIEdgeInsets, withPriority: Float = 1000) {
		let constraints = [
			childView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgeInsets.left),
			childView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgeInsets.right)
		].map { $0.setPriority(priority: withPriority) }
		
		removeConstraints(constraints)
		childView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints)
	}
	
	func setVerticalConstraintsToChild(_ childView: UIView, edgeInsets: UIEdgeInsets, withPriority: Float = 1000) {
		let constraints = [
			childView.topAnchor.constraint(equalTo: self.topAnchor, constant: edgeInsets.top),
			childView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -edgeInsets.bottom),
		].map { $0.setPriority(priority: withPriority) }
		
		removeConstraints(constraints)
		childView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints)
	}
	
	func setSafeAreaConstraintsToChild(_ childView:UIView,edgeInsets:UIEdgeInsets){
		let constraints = [
			childView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: edgeInsets.top),
			childView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -edgeInsets.bottom),
			childView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: edgeInsets.left),
			childView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -edgeInsets.right)
		]

		removeConstraints(constraints)
		childView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints)
	}
	
	func setCentralizedChild(_ childView:UIView){
		let constraints = [
			childView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			childView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		]

		removeConstraints(constraints)
		childView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints)
	}
	
	func removeSimilarConstraints(_ list:[NSLayoutConstraint]){
		constraints.forEach { item in
			guard list.filter(item.isSame).first != nil else {return}
			removeConstraint(item)
		}
	}
	
	func setFrameConstraints(width:CGFloat? = nil,height:CGFloat? = nil){
		widthAnchor.constraint(equalToConstant: width ?? 0).isActive = width != nil
		heightAnchor.constraint(equalToConstant: height ?? 0).isActive = height != nil
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setFrameConstraints(size:CGSize) {
		widthAnchor.constraint(equalToConstant: size.width).isActive = true
		heightAnchor.constraint(equalToConstant: size.height).isActive = true
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setWidthWithPriority(_ width:CGFloat,priority:UILayoutPriority = .defaultHigh) {
		let anchor = widthAnchor.constraint(equalToConstant: width)
		anchor.priority = priority
		anchor.isActive = true
	}
	
	func setHeightWithPriority(_ height:CGFloat,priority:UILayoutPriority = .defaultHigh) {
		let anchor = heightAnchor.constraint(equalToConstant: height)
		anchor.priority = priority
		anchor.isActive = true
	}
	
	func setWidthForChildWithPadding(_ childView:UIView,paddingFactor:CGFloat) {
		childView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: paddingFactor).isActive = true
		trailingAnchor.constraint(equalToSystemSpacingAfter: childView.trailingAnchor, multiplier: paddingFactor).isActive = true
	}
	
	func setHeightForChildWithPadding(_ childView:UIView,paddingFactor:CGFloat) {
		childView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: paddingFactor).isActive = true
		bottomAnchor.constraint(equalToSystemSpacingBelow: childView.bottomAnchor, multiplier: paddingFactor).isActive = true
	}
	
	func removeAllSubViews() {
		subviews.forEach { $0.removeFromSuperview() }
	}
	
	func setFrameLayout(childView: UIView,alignment: Alignment, paddingFactor: UIEdgeInsets = .zero) {
		var constraints: [NSLayoutConstraint]
		switch alignment {
		case .topLeading:
			constraints = [
				childView.topAnchor.constraint(equalTo: topAnchor,constant: paddingFactor.vertical),
				childView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: paddingFactor.horizontal)
			]
		case .top:
			constraints = [childView.topAnchor.constraint(equalTo: topAnchor,constant: paddingFactor.vertical)]
		case .topTrailing:
			constraints = [
				childView.topAnchor.constraint(equalTo: topAnchor,constant: paddingFactor.vertical),
				childView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: paddingFactor.horizontal)
			]
		case .leading:
			constraints = [childView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: paddingFactor.horizontal)]
		case .center:
			constraints = [
				childView.centerXAnchor.constraint(equalTo: centerXAnchor,constant: paddingFactor.horizontal),
				childView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: paddingFactor.vertical)
			]
		case .centerX:
			constraints = [childView.centerXAnchor.constraint(equalTo: centerXAnchor,constant: paddingFactor.horizontal)]
		case .centerY:
			constraints = [childView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: paddingFactor.vertical)]
		case .trailing:
			constraints = [childView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: paddingFactor.horizontal)]
		case .bottomLeading:
			constraints = [
				childView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: paddingFactor.vertical),
				childView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: paddingFactor.horizontal)
			]
		case .bottom:
			constraints = [childView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: paddingFactor.vertical)]
		case .bottomTrailing:
			constraints = [
				childView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: paddingFactor.vertical),
				childView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: paddingFactor.horizontal)
			]
		}
		
		removeConstraints(constraints)
		childView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints)
		
	}
}

//MARK: - Array Extension

extension Array where Element: UIView {
	
	func first(where id: String?) -> UIView? {
		guard let validFirst = id else { return nil }
		return filter{ $0.accessibilityIdentifier == validFirst }.first
	}
	
	func filterViews(exclude id: String) -> [Self.Element]? {
		compactMap { $0.accessibilityIdentifier == id ? nil : $0 }
	}
	
}

extension NSLayoutConstraint{
	
	func isSame(as other: NSLayoutConstraint) -> Bool {
		return firstItem === other.firstItem &&
			secondItem === other.secondItem &&
			firstAnchor === other.firstAnchor &&
			secondAnchor === other.secondAnchor
	}
	
	func setPriority(priority: Float) -> Self {
		let constraintWithPriority = self
		constraintWithPriority.priority = .init(rawValue: priority)
		return constraintWithPriority
	}

}

