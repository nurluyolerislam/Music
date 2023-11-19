//
//  BodyLabel.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

final class BodyLabel: UILabel {
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    //MARK: - Configuration Methods
    private func configureUI() {
        textColor                                 = .secondaryLabel
        font                                      = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory         = true
        adjustsFontSizeToFitWidth                 = true
        minimumScaleFactor                        = 0.75
        lineBreakMode                             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}
