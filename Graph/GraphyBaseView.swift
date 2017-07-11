//  Created by Songwen Ding on 3/12/16.
//  Copyright © 2016 DingSoung. All rights reserved.

import UIKit

@IBDesignable open class GraphyBaseView: UIView, UIGestureRecognizerDelegate {
    
    //MARK: - animate controller
    @IBInspectable public var animationDuration:CGFloat = 0.0
    internal var displayLink:CADisplayLink?
    /// start ~ stop: 0~1.0
    private var ticker:CGFloat = 1.0
    public var animationPercent:CGFloat {
        set {
            if self.animationDuration > 0 && newValue < 1.0 {
                self.ticker = newValue
                self.displayLinkTerminate(displayLink: &self.displayLink)
                self.displayLink = CADisplayLink(target: self, selector: #selector(GraphyBaseView.animatePercentTickHandle))
                self.displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            } else {
                self.ticker = 1.0
                self.setNeedsDisplay()
            }
        }
        get {
            return self.ticker
        }
    }
    @objc final private func animatePercentTickHandle() {
        if self.ticker < 1.0 {
            self.ticker = min(self.ticker + (1/60.0) / self.animationDuration, 1.0)
            self.setNeedsDisplay()
        } else {
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
    
    // MARK: - View life Cycle
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    open override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    open required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    internal func initialize() {
        self.isOpaque = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GraphyBaseView.tapGestureRecognized(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GraphyBaseView.tapGestureRecognized(recognizer:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(GraphyBaseView.pinchGestureRecognized(recognizer:)))
        pinchGestureRecognizer.delegate = self
        self.addGestureRecognizer(pinchGestureRecognizer)
    }
    private var _size:CGSize?
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if _size == self.bounds.size {
        } else {
            _size = self.bounds.size
            self.animationPercent = 0
        }
    }
    open override func draw(_ rect: CGRect) {}
    deinit {
        self.displayLinkTerminate(displayLink: &self.displayLink)
    }
    
    // MARK: - guesture recgnizer
    @objc open func tapGestureRecognized(recognizer: UITapGestureRecognizer) {}
    @objc open func pinchGestureRecognized(recognizer: UIPinchGestureRecognizer) {}
    
    // MARK: - touch
    internal var lastTouchPoint = CGPoint.zero
    internal var isTouchMoving = false
    public final override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isTouchMoving {} else {super.touchesBegan(touches, with: event)}
        guard let location = touches.first?.location(in: self) else {return}
        self.lastTouchPoint = location
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {return}
        let dx = location.x - lastTouchPoint.x
        let dy = location.y - lastTouchPoint.y
        if self.isTouchMoving || dy * dy + dx * dx < 8 * 8 {
            // do some thing
            self.lastTouchPoint = location
        } else {
            self.isTouchMoving = true
        }
        if self.isTouchMoving {} else {super.touchesMoved(touches, with: event)}
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isTouchMoving {} else {super.touchesEnded(touches, with: event)}
        if self.isTouchMoving {self.isTouchMoving = false}
        //do some thing
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isTouchMoving {} else {super.touchesCancelled(touches, with: event)}
        if self.isTouchMoving {self.isTouchMoving = false}
        //do some thing
    }
}
