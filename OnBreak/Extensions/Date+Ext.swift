//
//  UIDate+Ext.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-18.
//

import Foundation
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
