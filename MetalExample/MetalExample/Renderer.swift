//  Renderer.swift
//  MetalExample

import UIKit

class Renderer: NSObject {
    weak var metalLayer: CAMetalLayer! = nil

    var device: MTLDevice! = nil
    var commandQueue: MTLCommandQueue! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    // MTLDepthStencilState
    // MTLSamplerState
    // MTLTexture

    var vertexBuffer: MTLBuffer! = nil
    var timer: CADisplayLink! = nil
    
    init?(layer: CAMetalLayer) {
        // Ask for the default Metal device; this represents our GPU.
        if let defaultDevice = MTLCreateSystemDefaultDevice() {
            device = defaultDevice
        } else {
            print("Metal is not supported")
            return nil
        }
        self.commandQueue = self.device.makeCommandQueue()

        let defaultLibrary = device.makeDefaultLibrary()
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
        // MTLDepthStencilState
        // MTLSamplerState
        // MTLTexture
        super.init()

        self.metalLayer = layer;
        self.metalLayer.device = device
        self.metalLayer.pixelFormat = .bgra8Unorm
        self.metalLayer.framebufferOnly = true

        let vertexData:[Float] = [
            0.0, 0.5, 0.0,
            -1.0, -0.5, 0.0,
            1.0, -0.5, 0.0]
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        self.vertexBuffer = self.device.makeBuffer(bytes: vertexData, length: dataSize, options: MTLResourceOptions())

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
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(self.pipelineState)
        renderEncoder?.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder?.endEncoding()

        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }

    @objc func gameloop() {
        autoreleasepool {
            self.render()
        }
    }

}
