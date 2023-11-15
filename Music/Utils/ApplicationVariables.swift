//
//  ApplicationVariables.swift
//  Music
//
//  Created by Erislam Nurluyol on 15.11.2023.
//

import Foundation

struct ApplicationVariables {
    static let defaults = UserDefaults.standard
    
    static var currentUserID: String?{
        get{
            return defaults.string(forKey: "currentUserID")
        } set {
            defaults.set(newValue, forKey: "currentUserID")
        }
    }
    
    static func resetApplicationVariable(){
        defaults.removeObject(forKey: "currentUserID")
    }
}
