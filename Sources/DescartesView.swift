//  Created by Songwen Ding on 3/3/16.
//  Copyright © 2016 DingSoung All rights reserved.


import UIKit

public class DescartesView: GraphBaseView {
    @IBInspectable open var lineWidth:CGFloat = 3
    @IBInspectable open var lineColor:UIColor = UIColor.red
    @IBInspectable open var fillColor:UIColor = UIColor.clear
    
    //x = 16 * sin(t)^3
    //y = 13 * cos(t) - 5* cos(2*t) - 2 * cos(3*t) - cos(4*t)
    //width : height = 32 : 29
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let radius = min((rect.size.width - 2 * self.lineWidth) / 32.0, (rect.size.height - 2 * self.lineWidth) / 29.0)
        let origin = CGPoint(x: rect.size.width * 0.5, y: rect.size.height * 0.42)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: origin.x, y: origin.y - radius))
        let maxAngular = Int(self.animationPercent * 360)
        for angular in (0 ..< maxAngular) {
            let a = CGFloat(angular) / 180.0 * CGFloat(Double.pi)
            let x = 16 * pow(sin(a), 3)
            var y = 13.0 * cos(a)
                y += -5.0 * cos(2 * a)
                y += -2.0 * cos(3 * a)
            y = y - cos(4 * a)
            y = y * -1
            path.addLine(to: CGPoint(
                x: origin.x + radius * x,
                y: origin.y + radius * y))
        }
        //path.closePath()
        
        self.fillColor.setFill()
        path.fill()
        self.lineColor.setStroke()
        path.lineWidth = self.lineWidth
        path.stroke()
    }
    
}
