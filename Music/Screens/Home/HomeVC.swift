//
//  HomeVC.swift
//  Music
//
//  Created by Erislam Nurluyol on 7.11.2023.
//

import UIKit

protocol HomeVCInterface {
    func prepareTableView()
    func prepareDiscoverCollectionView()
    func prepareGenresCollectionView()
    func addTargets()
    func configureNavigationBar()
    func reloadTableView()
    func reloadDiscoverCollectionView()
    func reloadGenresCollectionView()
    func showProgressView()
    func dismissProgressView()
    func pushVC(vc : UIViewController)
    func presentVC(vc : UIViewController)
}

final class HomeVC: UIViewController {
    
    //MARK: - Variables
    private lazy var homeView = HomeView()
    private lazy var viewModel: HomeViewModelProtocol = HomeViewModel(view: self)
    
    
    //MARK: - Lifecycle
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK: - @Actions
    @objc private func browseButtonTapped() {
        let discoverVC = DiscoverVC(viewModel: viewModel)
        navigationController?.pushViewController(discoverVC, animated: true)
        
    }
    
    @objc private func exploreButtonTapped(){
        let genresVC = GenresVC(viewModel: viewModel)
        navigationController?.pushViewController(genresVC, animated: true)
    }
    
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let popularSongsResponse = viewModel.popularSongsResponse {
            if let tracks = popularSongsResponse.data {
                return tracks.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.popularSongsTableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID, for: indexPath) as! ProfileFavoriteTableViewCell
        
        
        let track = viewModel.tableViewCellForItem(at: indexPath)
        cell.updateUI(track: track)
        return cell
    }
    
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case homeView.discoverCollectionView:
            return 5
        case homeView.genresCollectionView:
            return 5
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case homeView.discoverCollectionView:
            let cell = homeView.discoverCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
                                                                           for: indexPath) as! MusicCollectionViewCell
            
            let playlist = viewModel.discoverCollectionViewCellForItem(at: indexPath)
            cell.updateUI(playlist: playlist)
            return cell
            
        case homeView.genresCollectionView:
            let cell = homeView.genresCollectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.reuseID,
                                                                         
                                                                         for: indexPath) as! MusicCollectionViewCell
            
            let genresPlaylist = viewModel.genresCollectionViewCellForItem(at: indexPath)
            cell.updateUI(genresPlaylist: genresPlaylist)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case homeView.discoverCollectionView:
            viewModel.discoverCollectionDidSelectItem(at: indexPath)
            
        case homeView.genresCollectionView:
            viewModel.genresCollectionDidSelectItem(at: indexPath)
            
        default:
            return
        }
    }
    
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.popularSongsDidSelectItem(at: indexPath)
    }
}


extension HomeVC: HomeVCInterface{
    
    func prepareTableView() {
        homeView.popularSongsTableView.register(ProfileFavoriteTableViewCell.self,
                                                forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
        homeView.popularSongsTableView.delegate = self
        homeView.popularSongsTableView.dataSource = self
    }
    
    func prepareDiscoverCollectionView() {
        homeView.discoverCollectionView.register(MusicCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        homeView.discoverCollectionView.dataSource = self
        homeView.discoverCollectionView.delegate = self
    }
    
    func prepareGenresCollectionView() {
        homeView.genresCollectionView.register(MusicCollectionViewCell.self,
                                               forCellWithReuseIdentifier: MusicCollectionViewCell.reuseID)
        homeView.genresCollectionView.delegate = self
        homeView.genresCollectionView.dataSource = self
    }
    
    func addTargets() {
        homeView.browseButton.addTarget(self, action: #selector(browseButtonTapped), for: .touchUpInside)
        homeView.exploreButton.addTarget(self, action: #selector(exploreButtonTapped), for: .touchUpInside)
    }
    
    func configureNavigationBar() { title = "Home" }
    
    func reloadTableView() { homeView.popularSongsTableView.reloadData() }
    
    func reloadDiscoverCollectionView() { homeView.discoverCollectionView.reloadData() }
    
    func reloadGenresCollectionView() { homeView.genresCollectionView.reloadData() }
    
    func showProgressView() {
        DispatchQueue.main.async {
            self.showLoading()
        }
    }
    
    func dismissProgressView() {
        dismissLoading()
    }
    
    func pushVC(vc : UIViewController) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentVC(vc: UIViewController) {
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
}
