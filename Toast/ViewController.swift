//
//  ViewController.swift
//  Toast
//
//  Created by devedbox on 2018/6/10.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit
import Dispatch

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
        
        let normalIndicator = ToastView.Component.ActivityIndicator.normal
        normalIndicator.frame.origin.x = 100.0
        normalIndicator.frame.origin.y = 100.0
        self.view.addSubview(normalIndicator)
        let breachedIndicator = ToastView.Component.ActivityIndicator.breachedRing
        breachedIndicator.frame.origin.x = 100.0
        breachedIndicator.frame.origin.y = 150.0
        self.view.addSubview(breachedIndicator)
        
        normalIndicator.isAnimating = true
        breachedIndicator.isAnimating = true
        
        let barProgress = ToastView.Component.ProgressIndicator.horizontalBar
        barProgress.frame.origin.x = 100.0
        barProgress.frame.origin.y = 200.0
        view.addSubview(barProgress)
        barProgress.progress = 0.2
        
        let pieProgress = ToastView.Component.ProgressIndicator.pie
        pieProgress.frame.origin.x = 100.0
        pieProgress.frame.origin.y = 250.0
        view.addSubview(pieProgress)
        pieProgress.progress = 0.8
        
        let ringProgress = ToastView.Component.ProgressIndicator.ring
        ringProgress.frame.origin.x = 100.0
        ringProgress.frame.origin.y = 300.0
        view.addSubview(ringProgress)
        ringProgress.progress = 0.4
        
        let colourredProgress = ToastView.Component.ProgressIndicator.colourredBar
        colourredProgress.frame.origin.x = 100.0
        colourredProgress.frame.origin.y = 350.0
        view.addSubview(colourredProgress)
        colourredProgress.progress = 1.0
        
        let contentView = ToastView.ContentView(frame: CGRect(origin: CGPoint(x: 100.0, y: 380.0), size: CGSize(width: 37.0, height: 37.0)))
        view.addSubview(contentView)
        contentView.style = .normal(opacity: 0.1)
        
        let contentView1 = ToastView.ContentView(frame: CGRect(origin: CGPoint(x: 100.0, y: 430.0), size: CGSize(width: 37.0, height: 37.0)))
        view.addSubview(contentView1)
        contentView1.style = .coloured(colors: [.blue, .green])
        
        let contentView2 = ToastView.ContentView(frame: CGRect(origin: CGPoint(x: 100.0, y: 480.0), size: CGSize(width: 37.0, height: 37.0)))
        view.addSubview(contentView2)
        contentView2.style = .translucent(style: .dark)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            contentView.style = .coloured(colors: [.red, .blue, .brown])
            contentView1.style = .normal(opacity: 0.7)
            contentView2.style = .translucent(style: .extraLight)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "alert", style: .plain, target: self, action: #selector(_handleAlert(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    private func _handleAlert(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
