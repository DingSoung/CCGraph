![Release](https://img.shields.io/github/release/DingSoung/Graph.svg)
![Status](https://travis-ci.org/DingSoung/Graph.svg?branch=master)
![Carthage](https://img.shields.io/badge/Carthage-compatible-yellow.svg?style=flat)
![Language](https://img.shields.io/badge/Swift-3.1-FFAC45.svg?style=flat)
![Platform](http://img.shields.io/badge/Platform-iOS-E9C2BD.svg?style=flat)
[![Donate](https://img.shields.io/badge/Donate-PayPal-9EA59D.svg)](https://paypal.me/DingSongwen)

# Graph
Core graphs and UIBezierPath

# QuartZ 2D

## 绘图要点
1. 绘图需要在context上
2. 区分(`UIKit` 和`Core Graphics`方式)

## 绘图方式
| 绘图方式            | 特点              | 说明                                       |
| :-------------- | :-------------- | :--------------------------------------- |
| `Core Graphics` | 在特定的context上绘制  | `Core Graphics`更接近底层，更灵活                 |
| `UIKit`         | 只能基于当前context绘制 | 接口简单，仅包含`UIImage`,`NSString`,`UIBezierPath`(是对`Core Graphics`框架关于path的封装), `UIColor` |

### UIKit方式
* 步骤
  1. 创建图形相应的UIBezierPath对象
  2. 设置一些修饰属性 
  3. 渲染
```swift
let path = UIBezierPath(ovalInRect: CGRectMake(0, 0, 100, 100))
UIColor.blueColor().setFill()
path.fill()
```
* 以上代码可以直接时用在一下地方
1. `UIGraphicsBeginImageContextWithOptions`会自动设置context为当前context
```Swift
UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), false, 0)
// code here...
let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
```
2. UIView 中drawrect， cocoa已配置好context为当前context
```Swift
public override func drawRect(rect: CGRect) {
    // code here
}
```
3. 其它情况，使用以下方式将context：参数转化为当前上下文，方便使用UIBezierPath方式绘制, 然后恢复上下文环境
```Swift
UIGraphicsPushContext(context)
// code here
UIGraphicsPopContext()
```

### Core Graphics方式
* 步骤类似于`UIBezierPath`
```Swift
CGContextAddEllipseInRect(context, CGRectMake(0, 0, 100, 100))
CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
CGContextFillPath(context)
```
* 如果持有context上下文，可以直接绘制
```Swift
func renderWithContext(context:CGContextRef) -> Void {
    // code here
}
```
* 如果没有，可以获取当前context
```swift
let optionalContext = UIGraphicsGetCurrentContext()
guard let context = optionalContext else { return }
// code here
```

### UIView 的 `drawRect`
* 默认情况下`UIView`不实现`drawRect`，会实现`drawLayer:inContext:`，程序不进入`drawRect`
* UIView的子类如`UILabel`可能会实现`drawRect`，继承他们时，若重写`drawRect`需要调用`supper`
* 若子类实现`drawRect`, `drawLayer:inContext`会调用`drawRect`
  [来源](https://www.zhihu.com/question/24387821)

## 异步线程绘制
创建绘图上下文，准备绘图资源，生成图片，都是占用CPU时间的，最后一步提交GPU渲染也会卡当前线程

| 绘制线程 | 适用情况                    | 代码                                       |
| :--- | :---------------------- | :--------------------------------------- |
| 异步线程 | 仅用于呈现画面，没有交互，容许延迟       | 任意context生成image，或调用`drawInRect`进一步绘制到界面上 |
| 主线程  | 涉及到交互，需要实时绘制，则应当遵循UIKit | 将绘图部分写在`drawRect`                        |

*另外还有OpenGL-ES(跨平台基于C API)绘图和Metal(基于OpenGL-ES封装的API，iOS8+ support) [DEMO](DEMO Open-GL/)
