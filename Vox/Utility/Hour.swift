//
//  Hour.swift
//  Vox
//
//  Created by Skander Thabet on 15/5/2022.
//

import Foundation
class Hour {
    static let hour = Hour()
    func getPriciseDateTime(firstname : String) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        var dayTime: String
        switch hour {
        case 6..<12 : dayTime = "Good Morning,\n\(firstname)"
            return dayTime
        case 12 : dayTime = "Good Day,\n\(firstname)"
            return dayTime
        case 13..<17 : dayTime =  "Good Afternoon,\n\(firstname)"
            return dayTime
        case 17..<22 : dayTime =  "Good Evening,\n\(firstname)"
            return dayTime
        default:  dayTime = "Good Night,\n\(firstname)"
            
        }
        return dayTime
    }
    
    
}
