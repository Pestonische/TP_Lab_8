import UIKit

struct Octopus {
    let corners: Int
    let smoothness: CGFloat
    
    func path(in rect: CGRect) -> UIBezierPath {
        guard corners >= 2 else { return UIBezierPath() }
       
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        var currentAngle = -CGFloat.pi / 2
        let angleAdjustment = .pi * 2 / CGFloat(corners * 2)
        
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness
        
        // we're ready to start with our path now
        let path = UIBezierPath()
        
        // move to our initial position
        path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))
        
        // track the lowest point we draw to, so we can center later
        var bottomEdge: CGFloat = 0
        var prevPoint: CGPoint
        
        // loop over all our points/inner points
        for corner in 0..<corners * 2 + 1  {
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: CGFloat
            
            if corner.isMultiple(of: 2) {
                bottom = center.y * sinAngle
                path.addCurve(to: CGPoint(x: center.x * cosAngle, y: bottom))
                prevPoint = CGPoint(x: center.x * cosAngle, y: bottom)
            } else {
                bottom = innerY * sinAngle
                path.addQuadCurve(to: CGPoint(x: innerX * cosAngle, y: bottom), controlPoint1: center, controlPoint2: prevPoint)
                prevPoint = CGPoint(x: innerX * cosAngle, y: bottom)
            }
            
            if bottom > bottomEdge {
                bottomEdge = bottom
            }
            
            currentAngle += angleAdjustment
        }
        
        let unusedSpace = (rect.height / 2 - bottomEdge) / 2
        
        let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
        path.apply(transform)
        return path
    }
    
    @IBDesignable class StarView: UIView {
        let gradientLayer = CAGradientLayer()
        let shapeLayer = CAShapeLayer()
        
        public override func draw(_ rect: CGRect) {
            shapeLayer.path = Octopus.init(corners: 6, smoothness: 0.5).path(in: frame).cgPath
            shapeLayer.fillColor = UIColor.red.cgColor
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 3.0
            shapeLayer.shadowRadius = 10.0
            shapeLayer.shadowOpacity = 0.8
            shapeLayer.shadowOffset = CGSize.zero
            layer.addSublayer(shapeLayer)
        }
    }
    
}
