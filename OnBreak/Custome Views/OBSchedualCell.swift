//
//  OBSchedualCell.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-25.
//
import UIKit
import SwipeCellKit

class SchedualCell: SwipeTableViewCell {
    static let reuseID = "SchedualCell"
    var timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTimeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureTimeLabel(){
        contentView.addSubview(timeLabel)
        timeLabel.textAlignment = .left
        timeLabel.font = .boldSystemFont(ofSize: 18)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ])
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
