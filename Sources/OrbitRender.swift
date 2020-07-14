//
//  OrbitRender.swift
//  DEMO
//
//  Created by Songwen Ding on 11/14/16.
//  Copyright © 2016 DingSoung. All rights reserved.
//

import UIKit

public class OrbitRender: NSObject {
    
    public func renderFrame(context:CGContext, frame:CGRect, points:[CGPoint]) {
        UIGraphicsPushContext(context)
        
        for point in points {
            let ovalPath = UIBezierPath(ovalIn: CGRect(x:point.x, y:point.y, width:5, height:5))
            UIColor.white.setFill()
            ovalPath.fill()
        }
        
        UIGraphicsPopContext()
    }
}
