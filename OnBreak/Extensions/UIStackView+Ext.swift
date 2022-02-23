//
//  UIView+Ext.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-17.
//

import UIKit

extension UIStackView {
    
    func addSubviews(_ views: UIView...){
        for view in views{ addArrangedSubview(view) }
    }
}
