//  Renderer.swift
//  MetalExample

import UIKit

class Renderer: NSObject {
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    var vertexBuffer: MTLBuffer! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var timer: CADisplayLink! = nil
    
    init?(layer: CAMetalLayer) {
        self.device = MTLCreateSystemDefaultDevice()

        self.metalLayer = layer;
        self.metalLayer.device = device
        self.metalLayer.pixelFormat = .bgra8Unorm
        self.metalLayer.framebufferOnly = true



        //open var device: MTLDevice?
        //open var pixelFormat: MTLPixelFormat

        //open var framebufferOnly: Boo
        //open var drawableSize: CGSize
        //open func nextDrawable() -> CAMetalDrawable?
        //open var presentsWithTransaction: Bool

        let vertexData:[Float] = [
            0.0, 0.5, 0.0,
            -1.0, -0.5, 0.0,
            1.0, -0.5, 0.0]
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        self.vertexBuffer = self.device.makeBuffer(bytes: vertexData, length: dataSize, options: MTLResourceOptions())

        let defaultLibrary = device.newDefaultLibrary()
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = defaultLibrary?.makeFunction(name: "basic_vertex")
        pipelineStateDescriptor.fragmentFunction = defaultLibrary?.makeFunction(name: "basic_fragment")
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            try self.pipelineState = self.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
            return nil
        }

        self.commandQueue = self.device.makeCommandQueue()

        super.init()

        self.timer = CADisplayLink(target: self, selector: #selector(Renderer.gameloop))
        self.timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }

    private override init() {
        super.init()
    }

    func render() {
        guard let drawable = self.metalLayer.nextDrawable() else {return}

        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)

        let commandBuffer = self.commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder.setRenderPipelineState(self.pipelineState)
        renderEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, at: 0)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func gameloop() {
        autoreleasepool {
            self.render()
        }
    }

}
