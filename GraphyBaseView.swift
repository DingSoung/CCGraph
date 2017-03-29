//  Created by Songwen Ding on 3/12/16.
//  Copyright © 2016 DingSoung. All rights reserved.

import UIKit

@IBDesignable public class GraphyBaseView: UIView {
    
    @IBInspectable public var animationDuration:CGFloat = 0.0
    internal var displayLink:CADisplayLink?
    internal var _animationPercent:CGFloat = 1.0
    public var animationPercent:CGFloat {
        set {
            if self.animationDuration > 0 && newValue < 1.0 {
                _animationPercent = newValue
                self.displayLinkTerminate(displayLink: &self.displayLink)
                self.displayLink = CADisplayLink(target: self, selector: #selector(GraphyBaseView.animatePercentTickHandle))
                self.displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            } else {
                _animationPercent = 1.0
                self.setNeedsDisplay()
            }
        }
        get {
            return _animationPercent
        }
    }
    @objc final private func animatePercentTickHandle() {
        if _animationPercent < 1.0 {
            _animationPercent += (1/60.0) / self.animationDuration
            self.setNeedsDisplay()
        } else {
            self.animationPercent = 1.0
            self.setNeedsDisplay()
            self.displayLinkTerminate(displayLink: &self.displayLink)
        }
    }
    
    final internal func displayLinkTerminate(displayLink: inout CADisplayLink?) {
        if (displayLink != nil) {
            //displayLink?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            displayLink?.invalidate() // also will remove from run loop
            displayLink = nil
        }
    }
    
    // MARK: - override UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
    }
    
    public required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private var lastSize:CGSize?
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if self.lastSize == self.bounds.size {
        } else {
            self.lastSize = self.bounds.size
            self.animationPercent = 0
        }
    }
    
    deinit {
        self.displayLinkTerminate(displayLink: &self.displayLink)
    }
    
    public override func draw(_ rect: CGRect) {
    }
}
