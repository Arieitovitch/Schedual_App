//
//  String+Ext.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-09-02.
//

import Foundation
extension String{
    
    // Unnessesairy
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
}
