//
//  GenresVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

import UIKit

final class GenresVC: UIViewController {
    
    //MARK: - Variables
    lazy var genresView = GenresView()
    let viewModel: HomeViewModelProtocol?
    
    
    //MARK: - Initializers
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        addDelegatesAndDataSources()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = genresView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    //MARK: - Helper Functions
    private func configureUI() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "Genres"
    }
    
    private func addDelegatesAndDataSources() {
        genresView.collectionView.register(MusicCollectionViewCell.self, forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        
        genresView.collectionView.dataSource = self
        genresView.collectionView.delegate = self
    }

}


extension GenresVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.genresVCnumberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID, for: indexPath) as! MusicCollectionViewCell
        
        if let viewModel {
            if let response = viewModel.genresResponse {
                if let genresPlaylists = response.data {
                    let genresPlaylist = genresPlaylists[indexPath.row]
                    cell.updateUI(genresPlaylist: genresPlaylist)
                }
            }
        }
        return cell
    }
    
}

extension GenresVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.GenresVCDidSelectItem(at: indexPath)
    }
}
