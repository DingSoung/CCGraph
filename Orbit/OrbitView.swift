//
//  OrbitView.swift
//  DEMO
//
//  Created by Songwen Ding on 11/14/16.
//  Copyright © 2016 DingSoung. All rights reserved.
//

import UIKit

public class OrbitView: GraphyBaseView {
    
    // MARK: - render property rconfig
    public var render = OrbitRender()
    
    
    var dots:[CGPoint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        self.isOpaque = false
        
        for x in 0..<100 {
            for y in 0..<10 {
                let point = CGPoint(x: 320.0 * CGFloat(x) / 100.0, y: 470.0 * CGFloat(y) / 10.0)
                self.dots.append(point)
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var lastDrawedImage:UIImage?
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let optionalContext = UIGraphicsGetCurrentContext()
         guard let context = optionalContext else { return }
        
        /*
         UIView  不支持保留上一次绘制状态
         线条无法设置填充颜色，不能设置渐变色
         可以使用BitMap Image的形式来做，中间会产生很多内存
         具体开发是用方块 还是 用点 看情况
         */
        self.lastDrawedImage?.draw(in: rect)
        self.render.renderFrame(context: context, frame: rect, points: self.dots)
    }
    /*
 self.displayLinkTerminate(displayLink: &self.displayLink)
 self.displayLink = CADisplayLink(target: self, selector: #selector(self.self.moveTickHandle))
 self.displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
 
 self.displayLinkTerminate(displayLink: &self.displayLink)
 */
 
    @objc final private func moveTickHandle() {
        // code here...
        self.lastDrawedImage = self.image(alpha: 0.9)
        for index in 0..<self.dots.count {
            var x = self.dots[index].x + CGFloat(RadomData.uInt(3));
            var y = self.dots[index].y + CGFloat(RadomData.uInt(5));
            if x > self.bounds.size.width {
                x = 0.0;
            }
            if y > self.bounds.size.height {
                y = 0.0;
            }
            self.dots[index] = CGPoint(x: x, y: y)
        }
        
        self.setNeedsDisplay()
        //self.displayLinkTerminate(displayLink: &self.displayLink)
    }
}
