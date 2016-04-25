//
//  TransparentHoleView.swift
//  ImageCrop
//
//  Created by David on 2016/4/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class TransparentHoleView: UIView {

	var reciever: UIView!
	
	init(frame: CGRect, radius: CGFloat) {
		super.init(frame: frame)
		
		let hole = holelayer(radius)
		layer.addSublayer(hole)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func holelayer(radius: CGFloat) -> CAShapeLayer {
		
		let borderPath = UIBezierPath(rect: UIScreen.mainScreen().bounds)
		let circlePath = UIBezierPath(ovalInRect: CGRect(x: UIScreen.mainScreen().bounds.width / 2 - radius, y: UIScreen.mainScreen().bounds.height / 2 - radius, width: radius * 2, height: radius * 2))
		borderPath.appendPath(circlePath)
		borderPath.usesEvenOddFillRule = true
		
		let holeLayer = CAShapeLayer()
		holeLayer.path = borderPath.CGPath
		holeLayer.fillRule = kCAFillRuleEvenOdd
		holeLayer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).CGColor
		
		return holeLayer
	}
	
	// pass the gesture on this view to the reciever
	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		if pointInside(point, withEvent: event) {
			return reciever
		}
		return nil
	}

}
