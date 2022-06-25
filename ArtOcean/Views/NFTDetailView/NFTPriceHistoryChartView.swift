//
//  NFTPriceHistoryChartView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/06/2022.
//

import Foundation
import UIKit

class NFTChartView:UIStackView{
	
	var prices:[Double] = []
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: -  View
	private lazy var chartView:ChartView = {
		let chartView = ChartView(data: prices)
//		chartView.chartDelegate = self
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
	
	private lazy var chartPriceView:UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		
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
		
		stack.addArrangedSubview(priceView)
		stack.addArrangedSubview(chartView)
		
		return stack
	}()
	
	//MARK: - UpdateUI
	func updateUI(){
		
	}
	
}

//MARK: -
