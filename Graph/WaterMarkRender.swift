//  Created by Songwen Ding on 2017/9/21.
//  Copyright © 2017年 Ding Soung. All rights reserved.

import UIKit

@objcMembers
public class WaterMarkRender: NSObject {
    /// angle 0~2 * pi, space 1~N
    class public final func render(context: CGContext,
                             text: String,
                             attributes:[NSAttributedStringKey: Any]?,
                             angle: CGFloat,
                             rect: CGRect,
                             scale: CGFloat) {
        let strSize = (text as NSString).size(withAttributes: attributes)
        let drawSize = CGSize(width: abs(cos(angle)) * strSize.width + abs(sin(angle)) * strSize.height,
                              height: abs(sin(angle)) * strSize.width + abs(cos(angle)) * strSize.height)
        let stepSize = CGSize(width: drawSize.width * scale, height: drawSize.height * scale)
        context.saveGState()
        var point = CGPoint(x: rect.origin.x, y: rect.origin.y + max(0, sin(angle) * strSize.width))
        while point.y < rect.maxY {
            point.x = rect.origin.x
            while point.x < rect.maxX {
                let t = CGAffineTransform(translationX: point.x, y: point.y)
                let r = CGAffineTransform(rotationAngle: -angle)
                context.concatenate(t)
                context.concatenate(r)
                (text as NSString).draw(at: CGPoint.zero, withAttributes: attributes)
                context.concatenate(r.inverted())
                context.concatenate(t.inverted())
                point.x += stepSize.width
            }
            point.y += stepSize.height
        }
        context.restoreGState()
        /* debug position
        var tempPoint = rect.origin
        while tempPoint.y < rect.maxY {
            tempPoint.x = rect.origin.x
            while tempPoint.x < rect.maxX {
                let path = UIBezierPath(rect: CGRect(origin: tempPoint, size: drawSize))
                path.lineWidth = 1
                UIColor.red.setStroke()
                path.stroke()
                tempPoint.x += stepSize.width
            }
            tempPoint.y += stepSize.height
        }*/
    }
}
