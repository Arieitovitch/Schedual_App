//
//  OBBreakCell.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-09-02.
//

import UIKit

class BreakCell: UITableViewCell {
    static let reuseID = "BreakCell"
    var view = UIView()
    var statusView = UIView()
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    var timeLabel = UILabel()
    var breakStatusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // add shadow on cell
        backgroundColor = .clear // very important
        configureView()
        configureNameLabel()
        configureEmailLabel()
        configureIsOnBreak()
        configureTimeLable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        contentView.addSubview(view)
        view.addSubviewsForView(statusView, nameLabel, emailLabel, timeLabel, breakStatusLabel)
        statusView.backgroundColor = .systemRed
        statusView.layer.cornerRadius = 12
        statusView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemFill
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            statusView.topAnchor.constraint(equalTo: view.topAnchor),
            statusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            statusView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    
    func configureNameLabel(){
        nameLabel.textAlignment = .left
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 7),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            nameLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureEmailLabel(){
        emailLabel.textAlignment = .left
        emailLabel.font = .boldSystemFont(ofSize: 12)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            emailLabel.leadingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 7),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            emailLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func configureIsOnBreak(){
        breakStatusLabel.textAlignment = .left
        breakStatusLabel.font = .boldSystemFont(ofSize: 18)
        breakStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            breakStatusLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 3),
            breakStatusLabel.leadingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 7),
            breakStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            breakStatusLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configureTimeLable(){
        contentView.addSubview(timeLabel)
        timeLabel.textAlignment = .left
        timeLabel.font = .boldSystemFont(ofSize: 16)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: breakStatusLabel.bottomAnchor, constant: 3),
            timeLabel.leadingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 7),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            timeLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
