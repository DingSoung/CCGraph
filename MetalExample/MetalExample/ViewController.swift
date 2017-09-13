//
//  ViewController.swift
//  MetalExample
//
//  Created by Songwen Ding on 2017/8/17.
//  Copyright © 2017年 Songwen Ding. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    var metalLayer: CAMetalLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        self.metalLayer = CAMetalLayer()
        self.view.layer.addSublayer(self.metalLayer)
        _ = Renderer(metalLayer: self.metalLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.metalLayer.frame = self.view.layer.bounds
    }
}

