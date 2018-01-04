//
//  ViewController.swift
//  FitGradientDemo
//
//  Created by cyrill on 2018/1/4.
//  Copyright © 2018年 cyrill.win. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let bar = FitGradient()
    
    var gradientView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func show(_ sender: Any) {
        bar.show()
    }
    
    @IBAction func hide(_ sender: Any) {
        bar.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

