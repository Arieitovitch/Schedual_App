//
//  Friend.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-25.
//

import Foundation

class Friend {
    
    init(name: String, email: String, breaks: [eventBreak], isOnBreak: Bool) {
        self.name = name
        self.email = email
        self.breaks = breaks
        self.isOnBreak = isOnBreak
    }
    
    let name: String
    let email: String
    let breaks: [eventBreak]
    var isOnBreak: Bool
}
