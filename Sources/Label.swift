//  Created by Songwen Ding on 2019/8/5.
//  Copyright © 2019 Songwen Ding. All rights reserved.

import UIKit
import Extension

@IBDesignable
open class Label: View {
    public var attributedText: NSAttributedString? {
        set {
            guard newValue != self.attributedText else {
                return
            }
            render.attributedString = newValue
            setNeedsDisplay()
        }
        get { return render.attributedString }
    }

    open override var frame: CGRect {
        didSet {
            guard self.frame != oldValue else {
                return
            }
            render.rect = bounds
            setNeedsDisplay()
        }
    }

    private let render = LabelRender()

    override open func draw(_ rect: CGRect) {
        guard var context = UIGraphicsGetCurrentContext() else {
            return
        }
        render.draw(context: &context)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return attributedText?.boundingRect(with: CGSize(width: size.width, height: 1000),
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            context: nil).size ?? .zero
    }
}

extension Label {
    public static let testAttrbuteString: NSAttributedString = {
        let string = NSMutableAttributedString()
        string.append(NSAttributedString(string: "普通文本测试abcd1234~`!@#$^😄", attributes: [:]))
        string.append(NSAttributedString(string: "\n粗体斜体字号颜色 Bold Italic Color", attributes: [
            .font: UIFont.systemFont(ofSize: 26).with([.traitItalic, .traitBold]),
            .foregroundColor: UIColor.red]))
        string.append(NSAttributedString(string: "\n删除线下划线 Strikethrough underline", attributes: [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.green]))
        string.append(NSAttributedString(string: #"""
 行间距，段间距，居中，单词换行，最低行高，最高行高，书写 natural， 行高 mut，段前间距
 hyphenationFactor，tabStops，defaultTabInterval，allowsDefaultTighteningForTruncation
 schoolmate，teacher，sunday，desktop
 """#
            , attributes: [
            .paragraphStyle: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = 5
                paragraph.paragraphSpacing = 20
                paragraph.alignment = .center
                paragraph.firstLineHeadIndent = 20
                paragraph.headIndent = 10
                paragraph.tailIndent = -10
                paragraph.lineBreakMode = .byCharWrapping
                paragraph.minimumLineHeight = 5
                paragraph.maximumLineHeight = 20
                paragraph.baseWritingDirection = .natural
                paragraph.lineHeightMultiple = 2
                paragraph.paragraphSpacingBefore = 3
                paragraph.hyphenationFactor = 0.9
                paragraph.tabStops = {
                    return [
                        NSTextTab(textAlignment: .center,
                                  location: 100,
                                  options: [.columnTerminators: NSCharacterSet(charactersIn: "，")]),
                        NSTextTab(textAlignment: .left,
                                  location: 10,
                                  options: [.columnTerminators: UIFont.systemFont(ofSize: 15)]),
                        NSTextTab(textAlignment: .right,
                                  location: 20,
                                  options: [:])
                    ]
                }()
                paragraph.defaultTabInterval = 2
                if #available(iOS 9.0, *) {
                    paragraph.allowsDefaultTighteningForTruncation = false
                } else {
                    // Fallback on earlier versions
                }
                return paragraph
            }()]))
        string.append(NSAttributedString(string: "\n一般按单词换行的 normally break by word", attributes: [
            .paragraphStyle: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineBreakMode = .byWordWrapping
                return paragraph
            }()
        ]))
        string.append(NSAttributedString(string: "\n有的文字我不想换行只是想试试试试就试试吧这个不重要", attributes: [
            .paragraphStyle: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineBreakMode = .byTruncatingTail
                return paragraph
            }()
        ]))
        string.append(NSAttributedString(string: "\n链接按字符换行 htww/baidu.com/?q=asss&asss=hbbshbhshs=sjhwhh", attributes: [
            .paragraphStyle: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineBreakMode = .byCharWrapping
                return paragraph
            }()
        ]))
        string.append(NSAttributedString(string: "\n表情也按字符换行 😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄",
                                         attributes: [
            .paragraphStyle: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineBreakMode = .byCharWrapping
                return paragraph
            }()
        ]))
        return string
    }()
}

class LabelRender {

    var attributedString: NSAttributedString? {
        didSet {
            if let attrStr = self.attributedString {
                framesetter = CTFramesetterCreateWithAttributedString(attrStr)
            } else {
                framesetter = nil
            }
        }
    }

    var rect: CGRect = .zero {
        didSet {
            self.path = CGPath(rect: self.rect, transform: nil)
        }
    }

    private var framesetter: CTFramesetter? {
        didSet {
            setFrame()
        }
    }

    private var path = CGPath(rect: .zero, transform: nil) {
        didSet {
            setFrame()
        }
    }

    private var frame: CTFrame?
    private func setFrame() {
        guard let attributedString = self.attributedString,
            let framesetter = self.framesetter else {
                return
        }
        frame = CTFramesetterCreateFrame(framesetter,
                                         CFRangeMake(0, attributedString.length),
                                         path,
                                         nil)
    }
}

extension LabelRender {
    @inline(__always)
    func draw(context: inout CGContext) {
        transform(context: &context)
        guard let attributedString = self.attributedString,
            let framesetter = self.framesetter else {
            return
        }
        let frame = CTFramesetterCreateFrame(framesetter,
                                             CFRangeMake(0, attributedString.length),
                                             path,
                                             nil)
        draw(frame: frame, context: context)
    }
}

extension LabelRender {
    private func transform(context: inout CGContext) {
        context.textMatrix = .identity
        context.translateBy(x: 0, y: rect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
    }

    private final func draw(frame: CTFrame, context: CGContext) {
         let lines = CTFrameGetLines(frame) as Array
        var lineOrigins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
        for index in 0..<lines.count {
            context.textPosition = lineOrigins[index]
            let line = unsafeBitCast(lines[index], to: CTLine.self)
            draw(line: line, context: context)
        }
    }

    private final func draw(line: CTLine, context: CGContext) {
        let runs = CTLineGetGlyphRuns(line) as Array
        runs.forEach {
            let run = unsafeBitCast($0, to: CTRun.self)
            CTRunDraw(run, context, CFRangeMake(0, 0))
            drawStrikethrough(run: run, context: context)
        }
    }
}

extension LabelRender {
    private final func drawStrikethrough(run: CTRun, context: CGContext) {
        guard let attributes = CTRunGetAttributes(run) as? [NSAttributedString.Key: Any],
            let strikethroughStyleNumber = attributes[.strikethroughStyle] as? NSNumber,
            let strikethroughColor = attributes[.strikethroughColor] as? UIColor,
            let font = attributes[.font] as? UIFont else {
                return
        }
        let strikethroughStyle = NSUnderlineStyle(rawValue: strikethroughStyleNumber.intValue)
        var lineWidth: CGFloat = 0
        if strikethroughStyle.contains(.thick) {
            lineWidth = 2
        } else if strikethroughStyle.contains(.single) {
            lineWidth = 1
        } else {
            return
        }
        let positions = LabelRanderHelper.getGlyphPoints(run: run)
        guard !positions.isEmpty else {
            return
        }
        let cpt = context.textPosition
        let strikeHeight = (font as AnyObject).xHeight * 0.5
            + positions[0].y
            + cpt.y
        let typographicWidth = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), nil, nil, nil)
        // start draw line
        context.beginPath()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(strikethroughColor.cgColor)
        context.move(to: CGPoint(x: cpt.x + positions[0].x, y: strikeHeight))
        context.addLine(to: CGPoint(x: cpt.x + positions[0].x + CGFloat(typographicWidth), y: strikeHeight))
        context.strokePath()
    }
}

class LabelRanderHelper {
    static func getGlyphPoints(run: CTRun) -> [CGPoint] {
        let glyphCount = CTRunGetGlyphCount(run)
        if let firstGlyphPosition = CTRunGetPositionsPtr(run) {
            return Array(UnsafeBufferPointer(start: firstGlyphPosition, count: glyphCount))
        } else {
            var points = [CGPoint](repeating: .zero, count: glyphCount)
            CTRunGetPositions(run, CFRangeMake(0, 0), &points)
            return points
        }
    }
}
