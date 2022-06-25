//
//  NFTPriceHistoryChartView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/06/2022.
//

import Foundation
import UIKit

protocol NFTChartViewDelegate{
	func scrollStarted()
	func scrollEnded()
}


class NFTChartView:UIView{
	
	var prices:[Double] = []
	
	public var delegate:NFTChartViewDelegate? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	//MARK: -  View
	private lazy var chartView:ChartView = {
		let chartView = ChartView()
		chartView.chartDelegate = self
		return chartView
	}()
	
	private lazy var priceChartLabel:CustomLabel = {
		let label = CustomLabel(text: String(format: "%.2f", prices.last ?? 0) + " ETH", size: 20, weight: .medium, color: .appGrayColor, numOfLines: 1)
		return label
	}()
	
	private lazy var priceChangeLabel:CustomLabel = {
		guard let first = prices.first , let last = prices.last else {return CustomLabel(text: "0%", color: .black, numOfLines: 1)}
		let label = CustomLabel(text: String(format: "%.2f%", (last - first)/last), size: 13, weight: .medium, color: last > first ? .appGreenColor : .appRedColor, numOfLines: 1, adjustFontSize: true, autoLayout: false)
		return label
	}()
	
	private lazy var priceValueStack:UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 8
		stack.addArrangedSubview(priceChartLabel)
		stack.addArrangedSubview(priceChangeLabel)
				
		priceChangeLabel.setContentHuggingPriority(.init(249), for: .horizontal)
		priceChangeLabel.setContentCompressionResistancePriority(.init(749), for: .horizontal)
		
		return stack
	}()
	
	private lazy var mainContainer:StackContainer = {
		let container = StackContainer(header: "Price History", innerView: [priceValueStack,chartView])
		return container
	}()
	
	private let loadingView:UIView = {
		let view = UIView()
		let loadingLabel = CustomLabel(text: "Loading...", size: 15, weight: .medium, color: .black, numOfLines: 1)
		view.addSubview(loadingLabel)
		view.setCentralizedChild(loadingLabel)
		view.backgroundColor = .white
		return view
	}()
		
	//MARK: - UpdateUI
	
	private func setupUI(){
		addSubview(mainContainer)
		addSubview(loadingView)
		setContraintsToChild(loadingView, edgeInsets: .zero)
		setContraintsToChild(mainContainer, edgeInsets: .zero)
	}
	
	private func resetView(){
		loadingView.removeFromSuperview()
		loadingView.constraints.forEach({removeConstraint($0)})
	}
	
	public func updateUI(_ prices:[Double]){
		self.prices = prices
		resetView()
		chartView.updateUI(prices)
		priceChangeLabel.text = String(format:"%.2f",(prices.overallChange() ?? 1.0)/(prices.last ?? 1.0))
		priceChangeLabel.textColor = prices.last! > prices.first! ? .appGreenColor : .appRedColor
		priceChartLabel.text = String(format: "%.2f", prices.last ?? 0.0)
	}
	override var intrinsicContentSize: CGSize{
		return .init(width: UIScreen.main.bounds.width, height: mainContainer.arrangedSubviews.compactMap({$0.intrinsicContentSize.height}).reduce(0, {$0 + $1}))
	}
}


//MARK: -  ChartViewDelegate
extension NFTChartView:ChartDelegate{
	
	func resetPriceAndChange(){
		if let first = prices.first,let last = prices.last {
			DispatchQueue.main.async {[weak self] in
				let percent = CGFloat(last - first)/CGFloat(last)
				self?.priceChartLabel.text = String(format: "%.2f", last) + " ETH"
				self?.priceChangeLabel.text = String(format: "%.2f", percent * 100) + "%"
				self?.priceChartLabel.textColor = .appGrayColor
				self?.priceChangeLabel.textColor = percent > 0 ? .appGreenColor : .appRedColor
			}
		}
	}
	
	func selectedPrice(_ price: Double) {
		if let last = prices.last{
			DispatchQueue.main.async {[weak self] in
				let percent = CGFloat(price - last)/CGFloat(price)
				self?.priceChartLabel.text = String(format: "%.2f", price) + " ETH"
				self?.priceChangeLabel.text = String(format: "%.2f", percent * 100) + "%"
				self?.priceChangeLabel.textColor = percent > 0 ? .appGreenColor : .appRedColor
				self?.priceChartLabel.textColor = last > price ? .appRedColor : .appGreenColor
			}
		}
	}
	
	func scrollEnded() {
		resetPriceAndChange()
		delegate?.scrollEnded()
	}
	
	func scrollStart() {
		delegate?.scrollStarted()
	}
	
}
