//
//  ChartView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 22/06/2022.
//

import Foundation
import UIKit

struct CurveSegments{
    var control1:CGPoint
    var control2:CGPoint
    
    static func computeCurvedSegments(from point1:CGPoint,to point2:CGPoint,curveFactor:CGFloat) -> CurveSegments{
        let diff = point2 - point1
        
        return .init(control1: .init(x: point1.x + diff.x * curveFactor , y: point1.y + diff.y * curveFactor), control2: .init(x: point2.x - diff.x  * curveFactor,y: point2.y - diff.y * curveFactor))
    }
}

protocol ChartDelegate{
    func selectedPrice(_ price:Double)
    func scrollEnded()
    func scrollStart()
}


class ChartView:UIView{
    
	private var data:[Double]!{
		didSet{
			resetChart()
			setupIndicator()
			drawChart()
		}
	}
    private var dataPoints:[CGPoint]!
    private var curvedSegments:[CurveSegments]!
    private var addChart:Bool = false
    private var chartColor:UIColor!
    
    public var chartDelegate:ChartDelegate? = nil
    
    init(data:[Double] = [],chartColor:UIColor = .appPurpleColor){
        super.init(frame: .zero)
        self.data = data
        self.chartColor = chartColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override var intrinsicContentSize: CGSize{
        return .init(width: UIScreen.main.bounds.width - 20, height: 200)
    }
    
    private lazy var chartPointIndicator:UIView = {
        let view = UIView()
        view.isHidden = true
        let sizes = Array(3...5).square()
        
        for size in sizes.enumerated(){
            let circle = UIView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            
            circle.backgroundColor = chartColor.withAlphaComponent(1/CGFloat(size.offset + 1))
            
            circle.layer.cornerRadius = CGFloat(size.element) * 0.5
            
            view.addSubview(circle)
            
            NSLayoutConstraint.activate([
                circle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                circle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                circle.widthAnchor.constraint(equalToConstant: CGFloat(size.element)),
                circle.heightAnchor.constraint(equalTo: circle.widthAnchor)
            ])
        }
        
        return view
    }()
	
}

//MARK: - ChartBuilder
extension ChartView{
    
    func computeDataPoints(){
        let spacing = data.count > 0 ? frame.width/CGFloat(data.count) : 40
        let height = frame.height - 50
        guard
        let min = data.min(),
        let max = data.max()
        else {return}
        
        for dataPoint in data.map({($0 - min)/(max - min)}).enumerated(){
            let point:CGPoint = .init(x: spacing * CGFloat(dataPoint.offset), y: (1 - CGFloat(dataPoint.element)) * height + 25)
            if dataPoints == nil{
                dataPoints = [point]
            }else{
                dataPoints.append(point)
            }
            
        }
        
    }
    
    func computeBezierCurve(){
        
        guard !data.isEmpty else {return}
        
        computeDataPoints()
        
        for i in 1..<dataPoints.count{
            if curvedSegments == nil{
                curvedSegments = [.computeCurvedSegments(from: dataPoints[i-1], to: dataPoints[i], curveFactor: 0.4)]
            }else{
                curvedSegments.append(.computeCurvedSegments(from: dataPoints[i-1], to: dataPoints[i], curveFactor: 0.4))
            }
        }
        
        if curvedSegments.isEmpty {return}
        
        for i in 1..<dataPoints.count - 1{
            let vector1 = curvedSegments[i - 1].control2
            let vector2 = curvedSegments[i].control1
            let anchor = dataPoints[i]
            let bezier1 = CGPoint(x: 2 * anchor.x - vector1.x, y: 2 * anchor.y - vector1.y)
            let bezier2 = CGPoint(x: 2 * anchor.x - vector2.x, y: 2 * anchor.y - vector2.y)

            curvedSegments[i].control1 = CGPoint(x: (bezier1.x + vector2.x) / 2, y: (bezier1.y + vector2.y) / 2)
            curvedSegments[i - 1].control2 = CGPoint(x: (bezier2.x + vector1.x) / 2, y: (bezier2.y + vector1.y) / 2)
        }
        
        
    }
    
    func drawBezierCurve() -> UIBezierPath{
        
        computeBezierCurve()
        
        guard !curvedSegments.isEmpty else {return UIBezierPath()}
        
        let path = UIBezierPath()
        
        path.move(to: dataPoints.first!)
        
        curvedSegments
            .enumerated()
            .forEach({
                path.addCurve(to: dataPoints[$0.offset + 1], controlPoint1: $0.element.control1, controlPoint2: $0.element.control2)
            })
        
        return path
    }
    
	func drawChart(){
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = drawBezierCurve().cgPath
		
		shapeLayer.strokeColor = chartColor.cgColor
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.lineWidth = 3
		layer.addSublayer(shapeLayer)
	}

}

//MARK: - TouchEventObservers

extension ChartView{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.25) {
            if self.chartPointIndicator.isHidden{
                self.chartPointIndicator.isHidden = false
            }
            self.chartDelegate?.scrollStart()
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let location  = touches.first?.location(in: self),
              let nearestPoint = dataPoints.findNearestPoint(location),
              let idx = dataPoints.firstIndex(where: {$0 == nearestPoint})
        else {return}
        UIView.animate(withDuration: 0.15,delay: 0,options:.curveEaseInOut) {
            self.chartPointIndicator.transform = .init(translationX: nearestPoint.x, y: nearestPoint.y)
            self.chartDelegate?.selectedPrice(self.data[idx])
        }

    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.25) {
            if !self.chartPointIndicator.isHidden{
                self.chartPointIndicator.isHidden = true
            }
            self.chartDelegate?.scrollEnded()
        }
    }
	
	private func setupIndicator(){
		addSubview(chartPointIndicator)
		
		chartPointIndicator.frame = .init(origin: .zero, size: .init(width: 25, height: 25))
		chartPointIndicator.frame = chartPointIndicator.frame.offsetBy(dx: -12.5, dy: -12.5)
	}
	
	private func resetChart(){
		if dataPoints != nil && !dataPoints.isEmpty{ dataPoints.removeAll() }
		if curvedSegments != nil && !curvedSegments.isEmpty{ curvedSegments.removeAll() }
		if addChart {addChart.toggle()}
				
		if !(layer.sublayers?.isEmpty ?? true){
			layer.sublayers?.forEach({$0.removeFromSuperlayer()})
		}
		
	}
	
	public func updateUI(_ data:[Double]){
		self.data = data
	}
}
