//
//  Int+Ext.swift
//  Music
//
//  Created by Erislam Nurluyol on 15.11.2023.
//

// MARK: - FormatTime Function
extension Int {
    func formatTime() -> String {
        let minutes = self / 60
        let remainingSeconds = self % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
