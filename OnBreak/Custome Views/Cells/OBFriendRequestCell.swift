//
//  FriendRequestCell.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-09-01.
//
import UIKit

protocol OBFreindRequestButtonTappedDeleget: class {
    func didTapAceptButton(email:String)
    func didTapRejectButton(email:String)
}

class FriendRequestCell: UITableViewCell {
    static let reuseID = "FriendRequestCell"
    var nameLabel = UILabel()
    var acceptButton = OBButton(backgroundcolor: .systemGreen, title: "Accept")
    var rejectButton = OBButton(backgroundcolor: .systemRed, title: "Reject")
    let stackView = UIStackView()
    
    weak var delegte: OBFreindRequestButtonTappedDeleget!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureNameLabel()
        configureStackView()
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
    
    func configureStackView(){
        acceptButton.isEnabled = true
        rejectButton.isEnabled = true
        acceptButton.isSelected = true
        rejectButton.isSelected = true
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubviews(acceptButton,rejectButton)
        acceptButton.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(didTapRejectButton), for: .touchUpInside)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ])
    }
    
    @objc func didTapAcceptButton(){
        delegte.didTapAceptButton(email: nameLabel.text!)
    }
    
    @objc func didTapRejectButton(){
        delegte.didTapRejectButton(email: nameLabel.text!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
