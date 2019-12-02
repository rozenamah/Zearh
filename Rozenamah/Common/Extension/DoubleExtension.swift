//
//  DoubleExtension.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 23.04.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

extension Double {
    
    enum DateFormat: String {
        case hour = "HH:mm"
        case date = "yyyy-MM-dd"
    }

    func dateToString(_ type: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: self)
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: date)
    }
}

