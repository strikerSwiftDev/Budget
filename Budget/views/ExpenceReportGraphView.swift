
import UIKit


enum ExpenceReportMode: Int {
    case month
    case week
}

//@IBDesignable

class ExpenceReportGraphView: UIView {

    private let offset: CGFloat = 10
    private let maxColumnLenth: CGFloat = 120.0
    
    private var startX: CGFloat = 0
    private var startY: CGFloat = 0

    private let weekDays = ["ПН","ВТ","СР","ЧТ","ПТ","СБ","ВС"]
    
    private var values = [Double]()
    
    private var reportMode = ExpenceReportMode.month
    
    private var labels = [UILabel]()
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let layers = layer.sublayers {
            for myLayer in layers {
                myLayer.removeFromSuperlayer()
            }
        }
        
        if !labels.isEmpty {
            for myLabel in labels {
                myLabel.removeFromSuperview()
            }
            labels.removeAll()
        }
        
        startX = offset
        startY = bounds.height - offset * 2

        
        drawBackground()
        drawReportGraph()
    }

    private func drawBackground () {
        
        let endX = bounds.width - offset
        
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
        
        switch reportMode {
            
            case .week:
            
                let collumnOffset = (bounds.width - offset * 2) / 8

                for i in 1...7 {
                    let label = UILabel()
                    label.frame = CGRect(x: 0, y: 0, width: offset * 4, height:  offset * 2)
                    label.center = CGPoint(x: startX + collumnOffset * CGFloat(i), y: startY + offset)
                    label.textAlignment = .center
                    label.backgroundColor = .clear
                    label.font = UIFont.systemFont(ofSize: 10)
                    label.text = weekDays[i - 1]

                    if i > 5 {
                        label.textColor = .red
                    } else {
                        label.textColor = .label
                    }
                    
                    label.isUserInteractionEnabled = false
                    addSubview(label)
                    labels.append(label)
                    
                    let myLayer = CAShapeLayer()
                    let path = UIBezierPath()
                    
                    path.move(to: CGPoint(x: startX + collumnOffset * CGFloat(i), y: startY))
                    path.addLine(to: CGPoint(x: startX + collumnOffset * CGFloat(i), y: endY))
                    
                    myLayer.lineDashPattern = [4, 6]
                    myLayer.path = path.cgPath
                    myLayer.strokeColor = UIColor.label.cgColor
                    myLayer.lineWidth = 1
                    myLayer.strokeEnd = 1
                    layer.addSublayer(myLayer)
                    
                }
            
            case .month:
                let collumnOffset = (bounds.width - offset * 2) / 31
            
                for i in 1...31 {
                    let newLayer = CAShapeLayer()
                    let newPath = UIBezierPath()

                    newPath.move(to: CGPoint(x: startX + collumnOffset * CGFloat(i), y: startY))
                    newPath.addLine(to: CGPoint(x: startX + collumnOffset * CGFloat(i), y: endY))

                    newLayer.path = newPath.cgPath
                    newLayer.strokeColor = UIColor.label.cgColor
                    newLayer.lineWidth = 0.3
                    newLayer.strokeEnd = 1
                    layer.addSublayer(newLayer)
                    
                    if i == 0 || i == 5 || i == 10 || i == 15 || i == 20 || i == 25 || i == 30 {
                        let label = UILabel()
                        label.frame = CGRect(x: 0, y: 0, width: offset * 4, height:  offset * 2)
                        label.center = CGPoint(x: startX + collumnOffset * CGFloat(i), y: startY + offset)
                        label.textAlignment = .center
                        label.backgroundColor = .clear
                        label.font = UIFont.systemFont(ofSize: 10)
                        label.text = String(i)
                        
                        newLayer.lineWidth = 1
                        
                        label.isUserInteractionEnabled = false
                        addSubview(label)
                        labels.append(label)
 
                        
                    }
                    
                }
        }

    }
    
    
    
    private func drawReportGraph() {
        guard !values.isEmpty else {return}
        
        guard let maxValue = values.max() else {return}

        let myLayer = CAShapeLayer()
        let myPath = UIBezierPath()
        
        var columnOffset: CGFloat = 0.0
        
        switch reportMode {
        case .month:
            columnOffset = (bounds.width - offset * 2) / 31
        case .week:
            columnOffset = (bounds.width - offset * 2) / 8
        }
     
        var iteration = 1

        for value in values {
            
            let multipler = value / maxValue

            let x0 = startX + columnOffset * CGFloat((iteration))
            let y1 = startY - maxColumnLenth * CGFloat(multipler)
            
            if iteration == 1 {
                myPath.move(to: CGPoint(x: startX, y: y1))
            }
            
            myPath.addLine(to: CGPoint(x: x0, y: y1))

            iteration += 1
            
        }
        
        myLayer.path = myPath.cgPath
        myLayer.strokeColor = UIColor.yellow.cgColor
        myLayer.fillColor = UIColor.clear.cgColor
        myLayer.lineWidth = 2
        myLayer.strokeEnd = 1
        
        layer.addSublayer(myLayer)
                   
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.33
        animation.fromValue = 0
        animation.toValue = 1
                   
        myLayer.add(animation, forKey: "lessAnimation")
        
    }
    
    public func setReportModeAndDisplayGraph(mode: ExpenceReportMode, compareObjects: [EspenceReportCompareObjectModel]) {
        reportMode = mode
        self.values = []
        
        for obj in compareObjects {
            values.append(obj.value ?? 0)
        }
        setNeedsDisplay()
    }

    
    
    
    
    
}
