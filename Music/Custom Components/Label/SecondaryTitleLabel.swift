//
//  SecondaryTitleLabel.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

final class SecondaryTitleLabel: UILabel {
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    //MARK: - Configuration Methods
    private func configureUI() {
        textColor                                 = .secondaryLabel
        adjustsFontForContentSizeCategory         = true
        adjustsFontSizeToFitWidth                 = true
        minimumScaleFactor                        = 0.90
        lineBreakMode                             = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
