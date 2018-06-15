//
//  SamplesViewController.swift
//  Toast
//
//  Created by devedbox on 2018/6/15.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

class SamplesViewController: UITableViewController {
    
    var animator: ToastAnimator = .none
    
    let tintColor = UIColor.white
    
    let pieProgressToast = ToastController.progress(.pie, message: "加载中...")
    let ringProgressToast = ToastController.progress(.ring, message: "加载中...")
    let barProgressToast = ToastController.progress(.horizontalBar, message: "加载中...")
    let colouredProgressToast = ToastController.progress(.colouredBar, message: "加载中...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "animator", style: .plain, target: self, action: #selector(_handleAnimator(_:)))
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(_handleTimer(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
}

extension SamplesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            _showTextOnly()
        case (0, 1):
            _showTextAndDetail()
        case (1, 0):
            _showSuccess()
        case (1, 1):
            _showError()
        case (2, 0):
            _showNormalAtivity()
        case (2, 1):
            _showBreachedRingActivity()
        case (3, 0):
            _showPieProgress()
        case (3, 1):
            _showRingProgress()
        case (3, 2):
            _showBarProgress()
        case (3, 3):
            _showColouredBarProgress()
        default:
            break
        }
    }
}

extension SamplesViewController {
    private func _showTextOnly() {
        let toast = ToastController.message("Some message.")
        toast.animator = animator
        toast.toastView.tintColor = tintColor
        toast.toastView.contentView.style = .coloured(colors: [.purple, .blue])
        toast.toastView.contentView.gradientLayer?.startPoint = CGPoint(x: 0.5, y: -0.5)
        toast.toastView.contentView.gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1.5)
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showTextAndDetail() {
        let toast = ToastController.message("Some message", detail: "Some detail message.")
        toast.animator = animator
        toast.toastView.tintColor = tintColor
        toast.toastView.contentView.style = .coloured(colors: [.orange, .red])
        toast.toastView.contentView.gradientLayer?.startPoint = CGPoint(x: 0.5, y: -0.5)
        toast.toastView.contentView.gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1.5)
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showSuccess() {
        let toast = ToastController.result(.success, message: "操作成功")
        toast.animator = animator
        toast.toastView.tintColor = .black
        toast.toastView.contentView.style = .translucent(style: .extraLight)
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showError() {
        let toast = ToastController.result(.error, message: "操作失败")
        toast.animator = animator
        toast.toastView.tintColor = .black
        toast.toastView.contentView.style = .translucent(style: .extraLight)
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showNormalAtivity() {
        let toast = ToastController.activity(.normal, message: "加载中...")
        toast.animator = animator
        toast.toastView.tintColor = tintColor
        toast.toastView.contentView.style = .normal(opacity: 0.7)
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showBreachedRingActivity() {
        let toast = ToastController.activity(.breachedRing, message: "加载中...")
        toast.animator = animator
        toast.toastView.tintColor = tintColor
        toast.toastView.contentView.style = .normal(opacity: 0.7)
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showPieProgress() {
        pieProgressToast.animator = animator
        pieProgressToast.toastView.tintColor = tintColor
        pieProgressToast.show(in: self, animated: true)
    }
    
    private func _showRingProgress() {
        ringProgressToast.animator = animator
        ringProgressToast.toastView.tintColor = tintColor
        ringProgressToast.show(in: self, animated: true)
    }
    
    private func _showBarProgress() {
        barProgressToast.animator = animator
        barProgressToast.toastView.tintColor = tintColor
        barProgressToast.show(in: self, animated: true)
    }
    
    private func _showColouredBarProgress() {
        colouredProgressToast.animator = animator
        colouredProgressToast.toastView.tintColor = tintColor
        colouredProgressToast.show(in: self, animated: true)
    }
}

extension SamplesViewController {
    @objc
    private func _handleAnimator(_ sender: UINavigationItem) {
        let alertController = UIAlertController(title: "animator", message: "Choose animator.", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "None", style: .default, handler: { _ in
            self.animator = .none
        }))
        alertController.addAction(UIAlertAction(title: "Zoom", style: .default, handler: { _ in
            self.animator = .zoom
        }))
        alertController.addAction(UIAlertAction(title: "Flip", style: .default, handler: { _ in
            self.animator = .flip
        }))
        alertController.addAction(UIAlertAction(title: "Drop", style: .default, handler: { _ in
            self.animator = .drop
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func _handleTimer(_ timer: Timer) {
        if case let progress? = barProgressToast.progress, progress >= 1.0 {
            barProgressToast.dismiss(animated: true)
            barProgressToast.progress = 0.01
        } else {
            barProgressToast.progress = barProgressToast.progress.map { $0 + 0.01 }
        }
        
        if case let progress? = ringProgressToast.progress, progress >= 1.0 {
            ringProgressToast.dismiss(animated: true)
            ringProgressToast.progress = 0.01
        } else {
            ringProgressToast.progress = ringProgressToast.progress.map { $0 + 0.01 }
        }
        
        if case let progress? = pieProgressToast.progress, progress >= 1.0 {
            pieProgressToast.dismiss(animated: true)
            pieProgressToast.progress = 0.01
        } else {
            pieProgressToast.progress = pieProgressToast.progress.map { $0 + 0.01 }
        }
        
        if case let progress? = colouredProgressToast.progress, progress >= 1.0 {
            colouredProgressToast.dismiss(animated: true)
            colouredProgressToast.progress = 0.01
        } else {
            colouredProgressToast.progress = colouredProgressToast.progress.map { $0 + 0.01 }
        }
    }
}
