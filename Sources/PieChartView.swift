//  Created by Songwen Ding on 1/13/16.
//  Copyright © 2016 DingSoung. All rights reserved.

import UIKit

public class PieChartModel: NSObject {
    var value:CGFloat = 0.0
    var color        = UIColor.white
    
    convenience init(value: CGFloat, color: UIColor) {
        self.init()
        self.value = value
        self.color = color
    }
}

public class  PieChartView: GraphBaseView {
    @IBInspectable open var lineWidth:CGFloat = 1.0
    open var fillColor:UIColor = UIColor.brown
    open var models:[PieChartModel] = [
        PieChartModel(value: 111, color: UIColor.red),
        PieChartModel(value: 222, color: UIColor.green),
        PieChartModel(value: 333, color: UIColor.blue),
    ]
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let radius = min(self.bounds.size.width, self.bounds.size.height) * 0.5
        let origin = CGPoint(x:self.bounds.size.width * 0.5, y:self.bounds.size.height * 0.5)
        
        var startAngular:CGFloat = 0
        var capacityAngular:CGFloat = 0
        var total:CGFloat = 0
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.setLineWidth(self.lineWidth)
        
        for model in self.models {
            total = total + model.value
        }
        if total <= 0 {
            return
        }
        for model in self.models {
            
            if (startAngular > self.animationPercent) {
                break
            }
            
            // Different Color.
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            self.fillColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            context.setStrokeColor(red: r, green: g, blue: b, alpha: a)
            model.color.getRed(&r, green: &g, blue: &b, alpha: &a)
            context.setFillColor(red: r, green: g, blue: b, alpha: a)
            
            // Different Size.
            capacityAngular = model.value / total;
            
            // Draw arc.
            context.move(to: origin);
            context.addArc(center: origin,
                           radius: radius,
                           startAngle: startAngular * 2 * CGFloat(Double.pi),
                           endAngle: min(self.animationPercent, startAngular + capacityAngular) * 2 * CGFloat(Double.pi),
                           clockwise:false) //绘制
            context.closePath(); //关闭起点和终点
            context.drawPath(using: CGPathDrawingMode.fillStroke); //渲染
            
            // net step
            startAngular = startAngular + capacityAngular;
        }
    }
}






