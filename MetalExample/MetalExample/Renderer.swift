//  Renderer.swift
//  MetalExample

import MetalKit

class Renderer: NSObject {
    weak var layer: CAMetalLayer!

    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    //let texture: MTLTexture
    let pipelineState: MTLRenderPipelineState
    let depthStencilState: MTLDepthStencilState
    let samplerState: MTLSamplerState

    var vertexBuffer: MTLBuffer! = nil
    var timer: CADisplayLink! = nil
    
    init?(metalLayer: CAMetalLayer) {
        layer = metalLayer;
        layer.pixelFormat = .bgra8Unorm
        layer.framebufferOnly = true

        // Ask for the default Metal device; this represents our GPU.
        if let defaultDevice = MTLCreateSystemDefaultDevice() {
            device = defaultDevice
        } else {
            print("Metal is not supported")
            return nil
        }
        commandQueue = device.makeCommandQueue()!

        /*
        let textureLoader = MTKTextureLoader(device: device)
        let asset = NSDataAsset.init(name: "checkerboard")
        guard let data = asset?.data else {
            print("Could not load image 'checkerboard' from an asset catalog in the main bundle")
            return nil
        }
        do {
            texture = try textureLoader.newTexture(data: data, options: nil)
        } catch {
            print("Unable to load texture from main bundle")
            return nil
        }*/

        let defaultLibrary = device.makeDefaultLibrary()
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = defaultLibrary?.makeFunction(name: "basic_vertex")
        pipelineStateDescriptor.fragmentFunction = defaultLibrary?.makeFunction(name: "basic_fragment")
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            try self.pipelineState = device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
            return nil
        }

        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)!

        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.sAddressMode = .repeat
        samplerDescriptor.tAddressMode = .repeat
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: samplerDescriptor)!

        super.init()

        layer.device = device
        
        let vertexData:[Float] = [
            0.0, 0.5, 0.0,
            -1.0, -0.5, 0.0,
            1.0, -0.5, 0.0]
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        self.vertexBuffer = self.device.makeBuffer(bytes: vertexData, length: dataSize, options: MTLResourceOptions())

        self.timer = CADisplayLink(target: self, selector: #selector(Renderer.render))
        self.timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }

    @objc func render() {
        //let timestep = 1.0 / TimeInterval(view.preferredFramesPerSecond)
        //updateWithTimestep(timestep)
        guard let drawable = layer.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            else { return }
        //renderEncoder.pushDebugGroup("Draw Cube")
        //renderEncoder.setFrontFacing(.counterClockwise)
        //renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset:0, index:0)
        //renderEncoder.setVertexBytes(&constants, length: MemoryLayout<Constants>.size, at: 1)
        //renderEncoder.setFragmentTexture(texture, at: 0)
        //renderEncoder.setFragmentSamplerState(samplerState, at: 0)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        //renderEncoder.popDebugGroup()
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
