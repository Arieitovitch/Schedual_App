//
//  OBdateButton.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-17.
//

import UIKit

class OBdateButton: UIButton {

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
        layer.cornerRadius = 15
        setTitleColor(UIColor(named: "textColor"), for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func set(backgroundColor: UIColor, title: String){
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }

}
