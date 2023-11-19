//
//  GenreArtistsView.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import UIKit

final class GenreArtistsView: UIView {
    
    //MARK: - UI Elements
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configuration Methods
    private func configureUI() {
        backgroundColor = .systemBackground
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        addSubview(collectionView)
        collectionView.fillSuperview(padding: .init(leading: 20,
                                                    trailing: 20))
    }

}
