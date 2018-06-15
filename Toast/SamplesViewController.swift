//
//  SamplesViewController.swift
//  Toast
//
//  Created by devedbox on 2018/6/15.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

class SamplesViewController: UITableViewController {
    
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
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showTextAndDetail() {
        let toast = ToastController.message("Some message", detail: "Some detail message.")
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showSuccess() {
        let toast = ToastController.result(.success, message: "操作成功")
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showError() {
        let toast = ToastController.result(.error, message: "操作失败")
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showNormalAtivity() {
        let toast = ToastController.activity(.normal, message: "加载中...")
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showBreachedRingActivity() {
        let toast = ToastController.activity(.breachedRing, message: "加载中...")
        toast.show(in: self, animated: true, duration: 1.5)
    }
    
    private func _showPieProgress() {
        
    }
    
    private func _showRingProgress() {
        
    }
    
    private func _showBarProgress() {
        
    }
    
    private func _showColouredBarProgress() {
        
    }
}
