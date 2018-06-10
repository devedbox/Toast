//
//  ViewController.swift
//  Toast
//
//  Created by devedbox on 2018/6/10.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let toastView = ToastView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // view.addSubview(toastView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        toastView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let normalIndicator = ToastView.Component.ActivityIndicator.normal
        normalIndicator.frame.origin.x = 100.0
        normalIndicator.frame.origin.y = 50.0
        self.view.addSubview(normalIndicator)
        let breachedIndicator = ToastView.Component.ActivityIndicator.breachedRing
        breachedIndicator.frame.origin.x = 100.0
        breachedIndicator.frame.origin.y = 100.0
        self.view.addSubview(breachedIndicator)
        
        normalIndicator.isAnimating = true
        breachedIndicator.isAnimating = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
