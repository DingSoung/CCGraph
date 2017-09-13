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

    var layer: CAMetalLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        self.layer = CAMetalLayer()
        _ = Renderer(layer: self.layer)

        self.view.layer.addSublayer(self.layer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layer.frame = self.view.layer.bounds
    }
}

