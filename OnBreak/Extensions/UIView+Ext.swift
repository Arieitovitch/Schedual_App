//
//  UIView+Ext.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-17.
//

import UIKit

extension UIView {
    
    func pinTogesEdges(of superview: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
    
    func addSubviewsForView(_ views: UIView...){
        for view in views{ addSubview(view) }
    }
}
