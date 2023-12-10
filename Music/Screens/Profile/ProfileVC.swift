//
//  ProfileVC.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit

protocol ProfileVCInterface {
    func updateUserPhoto(imageURL: URL)
    func updateUserName()
    func updateTableView()
    func dismissCreatePlaylistPopup()
    func showProgressView()
    func dismissProgressView()
    func configureViewDidLoad()
    func pushVC(vc: UIViewController)
    func presentVC(vc: UIViewController)
}

final class ProfileVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    // MARK: - Properties
    lazy var profileView = ProfileView()
    lazy var viewModel = ProfileViewModel()
    
    //MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        switch profileView.segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.getUserPlaylists()
        case 1:
            viewModel.getUserFavoriteTracks()
        default: return
        }
    }
    
    
    //MARK: - UI Configuration
    private func configureUI() {
        configureNavigationBar()
        configureSegmentedControll()
    }
    
    private func configureNavigationBar() {
        title = "Profile"
    }
    
    private func configureSegmentedControll(){
        profileView.segmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        profileView.createPlaylistButton.addTarget(self, action: #selector(createPlaylistButtonTapped), for: .touchUpInside)
        profileView.createPlaylistPopup.createButton.addTarget(self, action: #selector(createPlaylistPopupCreateButtonTapped), for: .touchUpInside)
        
        profileView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        profileView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - Helper Functions
    private func addDelegatesAndDataSources() {
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }
    
    
    //MARK: - @Actions
    @objc private func segmentValueChanged() {
        switch profileView.segmentedControl.selectedSegmentIndex {
        case 0:
            profileView.tableView.register(ProfilePlayListTableViewCell.self, forCellReuseIdentifier: ProfilePlayListTableViewCell.reuseID)
            viewModel.getUserPlaylists()
            profileView.createPlaylistButton.isHidden = false
        case 1:
            profileView.tableView.register(ProfileFavoriteTableViewCell.self, forCellReuseIdentifier: ProfileFavoriteTableViewCell.reuseID)
            viewModel.getUserFavoriteTracks()
            profileView.createPlaylistButton.isHidden = true
        default:
            break;
        }
    }
    
    @objc private func createPlaylistButtonTapped(){
        present(profileView.createPlaylistPopup, animated: true)
    }
    
    @objc private func createPlaylistPopupCreateButtonTapped(){
        guard let playlistName = profileView.createPlaylistPopup.textField.text else { return }
        if !playlistName.isEmpty {
            viewModel.createNewPlaylist(playlistName: playlistName)
        }
    }
    
    @objc private func  editButtonTapped() {
        print("------->>>>>> DEBUG: ")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        viewModel.uploadUserPhoto(imageData: (image!))
        self.dismiss(animated: true)
    }
    
    @objc private func logoutButtonTapped(){
        viewModel.logout {
            let loginVC = LoginVC()
            let nav = UINavigationController(rootViewController: loginVC)
            self.view.window?.rootViewController = nav
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch profileView.segmentedControl.selectedSegmentIndex {
        case 0:
            if let playlists = viewModel.playlists {
                return playlists.count
            }
        case 1:
            if let userFavoriteTracks = viewModel.userFavoriteTracks {
                return userFavoriteTracks.count
            }
            
        default:
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch profileView.segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = profileView.tableView.dequeueReusableCell(withIdentifier: ProfilePlayListTableViewCell.reuseID) as! ProfilePlayListTableViewCell
            
            if let userPlaylists = viewModel.playlists {
                let userPlaylist = userPlaylists[indexPath.row]
                cell.updateUI(userPlaylist: userPlaylist)
            }
            return cell
            
        case 1:
            let cell = profileView.tableView.dequeueReusableCell(withIdentifier: ProfileFavoriteTableViewCell.reuseID) as! ProfileFavoriteTableViewCell
            
            if let userFavoriteTracks = viewModel.userFavoriteTracks {
                let track = userFavoriteTracks[indexPath.row]
                cell.updateUI(track: track)
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch profileView.segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.playListsDidSelectRow(at: indexPath)
          
            
        case 1:
            viewModel.favoriteListsDidSelectRow(at: indexPath)
          
            
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch profileView.segmentedControl.selectedSegmentIndex {
        case 0:
            let removePlaylist = UIContextualAction(style: .destructive,
                                                    title: "Remove") { [weak self] action, view, bool in
                guard let self else { return }
                viewModel.removeFromPlayList(at: indexPath)
            }
            return UISwipeActionsConfiguration(actions: [removePlaylist])
            
        case 1:
            let removeFromFavoritesAction = UIContextualAction(style: .destructive,
                                                               title: "Remove") { [weak self] action, view, bool in
                guard let self else { return }
                if let userFavoriteTracks = viewModel.userFavoriteTracks {
                    let track = userFavoriteTracks[indexPath.row]
                    let vc = PlayerVC(track: track)
                    vc.viewModel?.delegate = self // TODO: - Sıkıntı Var Canoooo
                    vc.modalPresentationStyle = .pageSheet
                    self.present(vc, animated: true)
                }
            }
            return UISwipeActionsConfiguration(actions: [removeFromFavoritesAction])
            
        default:
            return nil
        }
    }
}

extension ProfileVC: ProfileVCInterface {
    func configureViewDidLoad() {
        addDelegatesAndDataSources()
        configureUI()
    }
    
    func showProgressView() {
        showLoading()
    }
    
    func dismissProgressView() {
        dismissLoading()
    }
    
    func updateUserPhoto(imageURL: URL) {
        profileView.userImage.kf.setImage(with: imageURL)
    }
    
    func updateUserName() {
        profileView.userName.text = viewModel.userName
    }
    
    func updateTableView() {
        profileView.tableView.reloadData()
    }
    
    func dismissCreatePlaylistPopup() {
        profileView.createPlaylistPopup.dismiss(animated: true)
    }
    
    func pushVC(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentVC(vc: UIViewController) {
        self.present(vc, animated: true)
    }
}


extension ProfileVC: PlayerViewModelDelegate {
    func updateFavorites() {
        if profileView.segmentedControl.selectedSegmentIndex == 1 {
            viewModel.getUserFavoriteTracks()
        }
    }
}
