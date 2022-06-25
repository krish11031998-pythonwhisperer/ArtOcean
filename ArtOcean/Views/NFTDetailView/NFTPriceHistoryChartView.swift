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


class NFTChartView:UIStackView{
	
	var prices:[Double] = []
	
	public var delegate:NFTChartViewDelegate? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
		guard let first = prices.first , let last = prices.last else {return CustomLabel(text: "No Price", color: .black, numOfLines: 1)}
		let label = CustomLabel(text: String(format: "%.2f", (last - first)/last), size: 13, weight: .medium, color: last > first ? .appGreenColor : .appRedColor, numOfLines: 1, adjustFontSize: true, autoLayout: false)
		return label
	}()
		
	//MARK: - UpdateUI
	
	private func setupUI(){
		axis = .vertical
		let priceHeader = CustomLabel(text: "Price History", size: 18, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: false, autoLayout: false)
	
		let priceValueStack = UIStackView()
		priceValueStack.axis = .horizontal
		priceValueStack.spacing = 8
		priceValueStack.addArrangedSubview(priceChartLabel)
		priceValueStack.addArrangedSubview(priceChangeLabel)
		
		priceValueStack.alignment = .firstBaseline
		
		priceChangeLabel.setContentHuggingPriority(.init(249), for: .horizontal)
		priceChangeLabel.setContentCompressionResistancePriority(.init(749), for: .horizontal)
		
		
		let priceView:UIStackView = UIStackView(arrangedSubviews: [priceHeader,priceValueStack])
		priceView.axis = .vertical
		priceView.spacing = 8
		
		addArrangedSubview(priceView)
		addArrangedSubview(chartView)
	}
	
	public func updateUI(_ prices:[Double]){
		self.prices = prices
		chartView.updateUI(prices)
		priceChangeLabel.text = String(format:"%.2f",(prices.overallChange() ?? 1.0)/(prices.last ?? 1.0))
		priceChangeLabel.textColor = prices.last! > prices.first! ? .appGreenColor : .appRedColor
		priceChartLabel.text = String(format: "%.2f", prices.last ?? 0.0)
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
