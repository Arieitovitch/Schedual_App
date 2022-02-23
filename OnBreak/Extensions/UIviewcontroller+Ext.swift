//
//  UIviewcontroller+Ext.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-13.
//

import UIKit

fileprivate var containerViewExt: UIView!

extension UIViewController {
    
    func showLoadingView(){
        containerViewExt = UIView(frame: view.bounds)
        view.addSubview(containerViewExt)
        
        containerViewExt.backgroundColor = .systemBackground
        containerViewExt.alpha = 0
        
        UIView.animate(withDuration: 0.25) { containerViewExt.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerViewExt.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func dismisLoadingView(){
        DispatchQueue.main.async {
            containerViewExt.removeFromSuperview()
            containerViewExt = nil
        }
    }
    
}
