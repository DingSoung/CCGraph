//  Created by Songwen Ding on 3/14/16.
//  Copyright © 2016 DingSoung. All rights reserved.

import UIKit

public class WhiteDotView: GraphyBaseView {
    
    @IBInspectable open var dimension:Int = 3
    @IBInspectable open var speed:CGFloat = 2
    open var lightColor = UIColor.lightGray
    open var darkColor = UIColor.darkGray
    open var models:[[Int]] = [[1]]
    fileprivate var startRow:Int = 0;
    fileprivate var offsetY:CGFloat = 0;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.models.count <= 0 {
            return
        }
        
        let dotWidth = rect.size.width / CGFloat(max(1, self.dimension))
        let dotHeight = dotWidth * 1.2
        let totalCount = Int(rect.size.height / dotHeight)
        
        self.offsetY += speed
        if self.offsetY >= 0 {
            self.offsetY = -1 * dotHeight
            
            self.startRow -= 1
            if self.startRow < 0 {
                self.startRow = self.models.count - 1
            }
        }
        
        var indexRow = self.startRow
        for rowCount in (0 ..< totalCount + 2) {
            if indexRow >= self.models.count {
                indexRow = 0
            }
            // draw line ar indexRow
            for indexColumn in (0 ..< min(self.dimension, self.models[indexRow].count)) {
                if models[indexRow][indexColumn] == 1 || models[indexRow][indexColumn] == 0 {
                    let rectanglePath = UIBezierPath(rect: CGRect(
                        x: CGFloat(indexColumn) * dotWidth,
                        y: CGFloat(rowCount) * dotHeight + self.offsetY,
                        width: dotWidth, height: dotHeight))
                    (models[indexRow][indexColumn] > 0 ? self.lightColor : self.darkColor).setFill()
                    rectanglePath.fill()
                    UIColor.white.setStroke()
                    rectanglePath.lineWidth = 1
                    rectanglePath.stroke()
                }
            }
            indexRow += 1
        }
    }
}
