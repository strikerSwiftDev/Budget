
import UIKit

@IBDesignable

class GraphView: UIView {
    
    private var compareObjects = [CompareObjectModel]()
    
    private let offset: CGFloat = 10
    private let columnWidth: CGFloat = 5
    private var zeroPoint: CGPoint!
    
    
    private var columnOffset: CGFloat = 20.0
    private let maxColumnLenth: CGFloat = 120.0
    private let minColumnLength: CGFloat = 10.0
   
    override func awakeFromNib() {
        
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
        
//Background
        
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
        
        backgroundPath2.move(to: CGPoint(x: startX, y: (startY - maxColumnLenth/2)))
        backgroundPath2.addLine(to: CGPoint(x: endX, y: (startY - maxColumnLenth/2)))
        
        backgroundLayer2.lineDashPattern = [6, 4]
        backgroundLayer2.path = backgroundPath2.cgPath
        backgroundLayer2.strokeColor = UIColor.label.cgColor
        backgroundLayer2.lineWidth = 1
        backgroundLayer2.strokeEnd = 1
        layer.addSublayer(backgroundLayer2)
        
//Foreground
        
        guard !compareObjects.isEmpty else {return}
        
        guard let maxValue = compareObjects.map({ $0.value }).max() else {return}
        
        var iteration = 1

        for compareObj in compareObjects {
            
            let paymentsLayer = CAShapeLayer()
            let paymentsPath = UIBezierPath()
            
            let x0 = startX + columnOffset * CGFloat((iteration))
            let multipler = compareObj.value / maxValue
            var y1 = startY - maxColumnLenth * CGFloat(multipler)
            if y1 < minColumnLength {
                y1 = minColumnLength
            }

            paymentsPath.move(to: CGPoint(x: x0, y: startY))
            paymentsPath.addLine(to: CGPoint(x: x0, y: y1))

            paymentsLayer.path = paymentsPath.cgPath
            paymentsLayer.strokeColor = compareObj.color.cgColor
            paymentsLayer.lineWidth = 10
            paymentsLayer.strokeEnd = 1
            layer.addSublayer(paymentsLayer)
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.33
            animation.fromValue = 0
            animation.toValue = 1
            
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            paymentsLayer.add(animation, forKey: "lessAnimation")

            iteration += 1
            
        }
       
    }
    

}
