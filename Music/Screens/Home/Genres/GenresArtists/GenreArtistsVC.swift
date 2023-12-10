//
//  GenreArtistsVC.swift
//  Music
//
//  Created by Yaşar Duman on 13.11.2023.
//

import UIKit

protocol GenreArtistsVCInterface{
    func updateUI()
    func pushVC(vc: UIViewController)
}

final class GenreArtistsVC: UIViewController {
    
    //MARK: - Variables
    let genreArtistsView = GenreArtistsView()
    let viewModel: GenreArtistsViewModel?
    
    
    //MARK: - Initializers
    init(genreId: String) {
        self.viewModel = GenreArtistsViewModel(genreId: genreId)
        super.init(nibName: nil, bundle: nil)
        viewModel?.view = self
        addDelegatesAndDataSources()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func loadView() {
        view = genreArtistsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Helper Functions
    private func addDelegatesAndDataSources() {
        genreArtistsView.collectionView.register(MusicCollectionViewCell.self, forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        
        genreArtistsView.collectionView.dataSource = self
        genreArtistsView.collectionView.delegate = self
    }
    
}

extension GenreArtistsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID, for: indexPath) as! MusicCollectionViewCell

        let artist = viewModel?.cellForItem(at: indexPath)
        cell.updateUI(artist: artist)
        return cell
    }
    
}

extension GenreArtistsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectItemAt(at: indexPath)
    }
}

extension GenreArtistsVC: GenreArtistsVCInterface {
    func updateUI() {
        genreArtistsView.collectionView.reloadData()
    }
    func pushVC(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
