//
//  OBFriendSearchCell.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-25.
//

import UIKit

class FriendSearchCell: UITableViewCell {
    static let reuseID = "FriendSearchCell"
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureNameLabel()
        configureEmailLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureNameLabel(){
        contentView.addSubview(nameLabel)
        nameLabel.textAlignment = .left
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
    }
    
    func configureEmailLabel(){
        contentView.addSubview(emailLabel)
        emailLabel.textAlignment = .left
        emailLabel.font = .boldSystemFont(ofSize: 14)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
