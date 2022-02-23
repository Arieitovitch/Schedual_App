//
//  OBButton.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-13.
//

import UIKit

class OBButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //custome code
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundcolor: UIColor, title: String){
        self.init(frame: .zero)
        self.backgroundColor = backgroundcolor
        self.setTitle(title, for: .normal)
    }
    
    
    private func configure(){
        layer.cornerRadius = 10
        setTitleColor(.systemGray5, for: .normal)
        setTitleColor(.white, for: .selected)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func set(backgroundColor: UIColor, title: String){
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }

}
