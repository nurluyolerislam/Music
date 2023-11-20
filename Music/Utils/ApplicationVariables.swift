//
//  ApplicationVariables.swift
//  Music
//
//  Created by Erislam Nurluyol on 15.11.2023.
//

import Foundation

struct ApplicationVariables {
    
    private static let defaults = UserDefaults.standard
    
    private init() {}
    
    static var currentUserID: String?{
        get{
            return defaults.string(forKey: "currentUserID")
        } set {
            defaults.set(newValue, forKey: "currentUserID")
        }
    }
    
    static func resetApplicationVariables(){
        defaults.removeObject(forKey: "currentUserID")
    }
    
}
