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
    weak var barProgress: ToastView.Component.ProgressIndicator?
    weak var pieProgress: ToastView.Component.ProgressIndicator?
    weak var ringProgress: ToastView.Component.ProgressIndicator?
    weak var colouredProgress: ToastView.Component.ProgressIndicator?

    let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(_handleTimer(_:)), userInfo: nil, repeats: true)
    
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        toastView.tintColor = UIColor(white: 1.0, alpha: 0.7)
        toastView.opacity = 0.3
        view.addSubview(toastView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let navigationBarFrame = navigationController?.navigationBar.frame
        toastView.frame = CGRect(origin: CGPoint(x: 0.0, y: navigationBarFrame?.maxY ?? 0.0),
                                 size: CGSize(width: view.bounds.width, height: (view.bounds.height - (navigationBarFrame?.height ?? 0.0)) * 0.5))
        let indicator = ToastView.Component.ActivityIndicator.normal
        indicator.layout.distribution = .vertical(at: .top)
        let indicator2 = ToastView.Component.ActivityIndicator.breachedRing
        indicator2.layout.distribution = .vertical(at: .bottom)
        toastView.add(component: indicator)
        toastView.add(component: indicator2)
        indicator.isAnimating = true
        indicator2.isAnimating = true
        let indicator3 = ToastView.Component.ProgressIndicator.pie
        indicator3.progress = 0.6
        indicator3.layout.distribution = .vertical(at: .top)
        // indicator3.layout.alignment = .trailing
        // indicator3.frame.size = CGSize(width: 120.0, height: 120.0)
        toastView.add(component: indicator3)
        
        let textLabel = ToastView.Component.Label()
        textLabel.numberOfLines = 0
        textLabel.text = "asdaidjaidjaiodjaiodjaoidhaoidbaodhaoisdhaiosdhaodhaoidhaiodhsoaihdddddddddddddddddddhdaoidhsiaohdioahdsoiahsoidhaiohsdahdaoihsdioahiosdhoaihdiohaiohdioahds"
        toastView.add(component: textLabel)
        
        toastView.contentView.style = .coloured(colors: [UIColor.purple.withAlphaComponent(0.79), UIColor.blue.withAlphaComponent(0.89)])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.toastView.remove(component: textLabel)
        }
        
        let normalIndicator = ToastView.Component.ActivityIndicator.normal
        normalIndicator.frame.origin.x = 100.0
        normalIndicator.frame.origin.y = 100.0
        self.view.insertSubview(normalIndicator, at: 0)
        let breachedIndicator = ToastView.Component.ActivityIndicator.breachedRing
        breachedIndicator.frame.origin.x = 100.0
        breachedIndicator.frame.origin.y = 150.0
        self.view.insertSubview(breachedIndicator, at: 0)
        
        normalIndicator.isAnimating = true
        breachedIndicator.isAnimating = true
        
        let barProgress = ToastView.Component.ProgressIndicator.horizontalBar
        barProgress.frame.origin.x = 100.0
        barProgress.frame.origin.y = 200.0
        view.insertSubview(barProgress, at: 0)
        self.barProgress = barProgress
        barProgress.progress = 0.2
        
        let pieProgress = ToastView.Component.ProgressIndicator.pie
        pieProgress.frame.origin.x = 100.0
        pieProgress.frame.origin.y = 250.0
        view.insertSubview(pieProgress, at: 0)
        self.pieProgress = pieProgress
        pieProgress.progress = 0.8
        
        let ringProgress = ToastView.Component.ProgressIndicator.ring
        ringProgress.frame.origin.x = 100.0
        ringProgress.frame.origin.y = 300.0
        view.insertSubview(ringProgress, at: 0)
        self.ringProgress = ringProgress
        ringProgress.progress = 0.4
        
        let colourredProgress = ToastView.Component.ProgressIndicator.colouredBar
        colourredProgress.frame.origin.x = 100.0
        colourredProgress.frame.origin.y = 350.0
        view.insertSubview(colourredProgress, at: 0)
        self.colouredProgress = colourredProgress
        colourredProgress.progress = 1.0
        
        let contentView = ToastView.ContentView(frame: CGRect(origin: CGPoint(x: 100.0, y: 380.0), size: CGSize(width: 37.0, height: 37.0)))
        view.insertSubview(contentView, at: 0)
        contentView.style = .normal(opacity: 0.1)
        
        let contentView1 = ToastView.ContentView(frame: CGRect(origin: CGPoint(x: 100.0, y: 430.0), size: CGSize(width: 37.0, height: 37.0)))
        view.insertSubview(contentView1, at: 0)
        contentView1.style = .coloured(colors: [.blue, .green])
        
        let contentView2 = ToastView.ContentView(frame: CGRect(origin: CGPoint(x: 100.0, y: 480.0), size: CGSize(width: 37.0, height: 37.0)))
        view.insertSubview(contentView2, at: 0)
        contentView2.style = .translucent(style: .dark)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            contentView.style = .coloured(colors: [.red, .blue, .brown])
            contentView1.style = .normal(opacity: 0.7)
            contentView2.style = .translucent(style: .extraLight)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "show", style: .plain, target: self, action: #selector(_handleAlert(_:)))
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(_handleTimer(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    private func _handleAlert(_ sender: UIBarButtonItem) {
        // let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        // alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        // self.present(alert, animated: true, completion: nil)
        
        let indicator = ToastView.Component.ActivityIndicator.breachedRing
        indicator.isAnimating = true
        let textLabel = ToastView.Component.Label()
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.boldSystemFont(ofSize: 14)
        textLabel.text = "加载中..."
        textLabel.layout.insets = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 10.0, right: 12.0)
        let toast = ToastController(components: [indicator, textLabel])
        toast.toastView.tintColor = .white
        toast.toastView.isTouchingThroughEnabled = true
        // toast.toastView.contentView.style = toastView.contentView.style
        toast.show(in: self, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            toast.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func _handleTimer(_ timer: Timer) {
        if case let progress? = barProgress?.progress, progress >= 1.0 {
            barProgress?.progress = 0.01
        } else {
            barProgress?.progress += 0.01
        }
        if case let progress? = pieProgress?.progress, progress >= 1.0 {
            pieProgress?.progress = 0.01
        } else {
            pieProgress?.progress += 0.01
        }
        if case let progress? = ringProgress?.progress, progress >= 1.0 {
            ringProgress?.progress = 0.01
        } else {
            ringProgress?.progress += 0.01
        }
        if case let progress? = colouredProgress?.progress, progress >= 1.0 {
            colouredProgress?.progress = 0.1
        } else {
            colouredProgress?.progress += 0.1
        }
    }
}
