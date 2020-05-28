//
//  GraphView.swift
//  Budget
//
//  Created by Anatoliy Anatolyev on 03.05.2020.
//  Copyright © 2020 Anatoliy Anatolyev. All rights reserved.
//

import UIKit

@IBDesignable

class GraphView: UIView {

//    private var paymentsArr = [(Float, UIColor)]()
    
    private var compareObjects = [CompareObjectModel]()
    
    private let offset: CGFloat = 10
    private let columnWidth: CGFloat = 5
    private var zeroPoint: CGPoint!
    
   
    override func awakeFromNib() {
//        print("!!!!!!!!!")
    }
    
    func updateCompareData(compareObjects: [CompareObjectModel]) {
        self.compareObjects = compareObjects
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let layers = layer.sublayers {
            for myLayer in layers {
                myLayer.removeFromSuperlayer()
            }
        }
//        paymentsArr = [(130, .blue), (60, . green), (100, .gray), (140, .orange), (90, .label), (130, .blue), (60, . green), (100, .gray), (140, .orange), (90, .label)]
        
        let startX: CGFloat = offset
        let endX = bounds.width - offset
        
        let startY = bounds.height - offset
        let endY = offset
        
        let backgroundLayer = CAShapeLayer()
        let backgroundPath = UIBezierPath()
        
        backgroundPath.move(to: CGPoint(x: startX, y: startY))
        backgroundPath.addLine(to: CGPoint(x: startX, y: endY))
        backgroundPath.move(to: CGPoint(x: startX, y: startY))
        backgroundPath.addLine(to: CGPoint(x: endX, y: startY))
        
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.strokeColor = UIColor.label.cgColor
        backgroundLayer.lineWidth = 1
        backgroundLayer.strokeEnd = 1
        layer.addSublayer(backgroundLayer)
        
        
        let backgroundLayer2 = CAShapeLayer()
        let backgroundPath2 = UIBezierPath()
        
        backgroundPath2.move(to: CGPoint(x: startX, y: bounds.midY))
        backgroundPath2.addLine(to: CGPoint(x: endX, y: bounds.midY))
        
        backgroundLayer2.lineDashPattern = [6, 4]
        backgroundLayer2.path = backgroundPath2.cgPath
        backgroundLayer2.strokeColor = UIColor.label.cgColor
        backgroundLayer2.lineWidth = 1
        backgroundLayer2.strokeEnd = 1
        layer.addSublayer(backgroundLayer2)
        
        
        
        
        var iteration = 1
        
        for compareObj in compareObjects {
            
            let paymentsLayer = CAShapeLayer()
            let paymentsPath = UIBezierPath()
            
            let x0 = startX + CGFloat(20.0) * CGFloat((iteration))
//            let y1 = startY - CGFloat(value)
            let y1 = startY - 100
            
            paymentsPath.move(to: CGPoint(x: x0, y: startY))
            paymentsPath.addLine(to: CGPoint(x: x0, y: y1))

            paymentsLayer.path = paymentsPath.cgPath
            paymentsLayer.strokeColor = compareObj.color.cgColor
            paymentsLayer.lineWidth = 10
            paymentsLayer.strokeEnd = 1
            layer.addSublayer(paymentsLayer)
            
            iteration += 1
            
        }
       
    }
    

}
