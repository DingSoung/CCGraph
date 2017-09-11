//
//  ViewController.swift
//  MetalExample
//
//  Created by Songwen Ding on 2017/8/17.
//  Copyright © 2017年 Songwen Ding. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class ViewController: UIViewController {
    
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    var vertexBuffer: MTLBuffer! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    
    var timer: CADisplayLink! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.device = MTLCreateSystemDefaultDevice()
        
        self.metalLayer = CAMetalLayer()
        self.metalLayer.device = device
        self.metalLayer.pixelFormat = .bgra8Unorm
        self.metalLayer.framebufferOnly = true
        self.metalLayer.frame = view.layer.frame
        self.view.layer.addSublayer(self.metalLayer)
        
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
        }
        
        self.commandQueue = self.device.makeCommandQueue()
        
        self.timer = CADisplayLink(target: self, selector: #selector(ViewController.gameloop))
        self.timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.metalLayer.frame = self.view.bounds
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

