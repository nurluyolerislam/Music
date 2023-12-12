//
//  ProfileVMTests.swift
//  MusicTests
//
//  Created by Yaşar Duman on 12.12.2023.
//

@testable import Music
import XCTest

final class ProfileVMTests: XCTestCase {
    private var viewModel: ProfileViewModel!
    private var view: MockProfileVC!
    private var firestoreManager: MockFirestoreManager!
    private var firebaseAuthManager: MockFirebaseAuthManager!
    private var firebaseStorageManager: MockFirebaseStorageManager!
    
    
    
    override func setUp() {
        super.setUp()
        view = .init()
        firestoreManager = .init()
        firebaseAuthManager = .init()
        firebaseStorageManager = .init()
        viewModel = .init(view: view,
                          firestoreManager: firestoreManager,
                          firebaseAuthManager: firebaseAuthManager,
                          firebaseStorageManager: firebaseStorageManager)
    }
    
    override func tearDown() {
        super.tearDown()
        firestoreManager = nil
        firebaseAuthManager = nil
        firebaseStorageManager = nil
        viewModel = nil
    }
    
    func test_viewDidLoad_InvokesRequiredMethods() {
        XCTAssertFalse(view.invokedConfigureNavigationBar)
        XCTAssertFalse(view.invokedAddTargets)
        XCTAssertFalse(view.invokedPrepareTableView)
        XCTAssertFalse(view.invokedShowProgressView)
        XCTAssertFalse(firestoreManager.invokedGetUserName)
        XCTAssertFalse(view.invokedUpdateUserName)
        XCTAssertFalse(view.invokedDismissProgressView)
        XCTAssertFalse(firebaseStorageManager.invokedFetchUserImage)
        XCTAssertFalse(view.invokedUpdateUserPhoto)
        
        viewModel.viewDidLoad()
        
        XCTAssertEqual(view.invokedConfigureNavigationBarCount, 1)
        XCTAssertEqual(view.invokedAddTargetsCount, 1)
        XCTAssertEqual(view.invokedPrepareTableViewCount, 1)
        XCTAssertEqual(view.invokedShowProgressViewCount, 2)
        XCTAssertEqual(firestoreManager.invokedGetUserNameCount, 1)
        XCTAssertEqual(view.invokedUpdateUserNameCount, 1)
        XCTAssertEqual(view.invokedDismissProgressViewCount, 2)
        XCTAssertEqual(firebaseStorageManager.invokedFetchUserImageCount, 1)
        XCTAssertEqual(view.invokedUpdateUserPhotoCount, 1)
    }
    
    
    func test_removeTrackFromFavorites_InvokesRequiredMethods() {
        XCTAssertFalse(firestoreManager.invokedRemoveTrackFromFavorites)
        XCTAssertTrue(firestoreManager.invokedRemoveTrackFromFavoritesParametersList.isEmpty)
        XCTAssertFalse(firestoreManager.invokedGetUserFavoriteTracks)
        XCTAssertFalse(view.invokedUpdateTableView)
        
        
        viewModel.userFavoriteTracks = [MockData.mockTrack]
        viewModel.removeTrackFromFavorites(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(firestoreManager.invokedRemoveTrackFromFavoritesCount, 1)
        XCTAssertTrue(firestoreManager.invokedRemoveTrackFromFavoritesParametersList.map(\.track) is [Track])
        XCTAssertEqual(firestoreManager.invokedGetUserFavoriteTracksCount, 1)
        XCTAssertEqual(view.invokedUpdateTableViewCount, 2)
    }
    
    func test_getUserPlaylists_FetchPlayLists() {
        XCTAssertFalse(firestoreManager.invokedGetUserPlaylists)
        XCTAssertFalse(view.invokedUpdateTableView)
        
        viewModel.getUserPlaylists()
        
        
        XCTAssertEqual(firestoreManager.invokedGetUserPlaylistsCount, 1)
        XCTAssertEqual(view.invokedUpdateTableViewCount, 1)
    }
    
    func test_getUserFavoriteTracks_FetchtUserFavoritesTracks() {
        XCTAssertFalse(firestoreManager.invokedGetUserFavoriteTracks)
        XCTAssertFalse(view.invokedUpdateTableView)
        
        viewModel.getUserFavoriteTracks()
        
        XCTAssertEqual(firestoreManager.invokedGetUserFavoriteTracksCount, 1)
        XCTAssertEqual(view.invokedUpdateTableViewCount, 1)
    }
    
    func test_createNewPlaylist_CreateNewPlayList() {
        XCTAssertFalse(firestoreManager.invokedCreateNewPlaylist)
        XCTAssertTrue(firestoreManager.invokedCreateNewPlaylistParametersList.isEmpty)
        XCTAssertFalse(firestoreManager.invokedGetUserPlaylists)
        XCTAssertFalse(view.invokedUpdateTableView)
        XCTAssertFalse(view.invokedDismissCreatePlaylistPopup)
        
        viewModel.createNewPlaylist(playlistName: "Test")
        
        XCTAssertEqual(firestoreManager.invokedCreateNewPlaylistCount, 1)
        XCTAssertTrue(firestoreManager.invokedCreateNewPlaylistParametersList.map(\.playlistName) is [String])
        XCTAssertEqual(firestoreManager.invokedGetUserPlaylistsCount, 1)
        XCTAssertEqual(view.invokedUpdateTableViewCount, 1)
        XCTAssertEqual(view.invokedDismissCreatePlaylistPopupCount, 1)
    }
    
    func test_uploadUserPhoto_InvokesRequiredMethods() {
        XCTAssertFalse(firebaseStorageManager.invokedUploadUserImage)
        XCTAssertTrue(firebaseStorageManager.invokedUploadUserImageParametersList.isEmpty)
        XCTAssertFalse(view.invokedShowProgressView)
        XCTAssertFalse(firebaseStorageManager.invokedFetchUserImage)
        XCTAssertFalse(view.invokedUpdateUserPhoto)
        XCTAssertFalse(view.invokedDismissProgressView)
        
        viewModel.uploadUserPhoto(imageData: UIImage(systemName: "heart")!)
        
        XCTAssertEqual(firebaseStorageManager.invokedUploadUserImageCount, 1)
        XCTAssertTrue(firebaseStorageManager.invokedUploadUserImageParametersList.map(\.image) is [UIImage])
        XCTAssertEqual(view.invokedShowProgressViewCount, 1)
        XCTAssertEqual(firebaseStorageManager.invokedFetchUserImageCount, 1)
        XCTAssertEqual(view.invokedUpdateUserPhotoCount, 1)
        XCTAssertEqual(view.invokedDismissProgressViewCount, 1)
    }
        
    func test_logout_InvokesRequiredMethods() {
        XCTAssertFalse(firebaseAuthManager.invokedSignOut)
  
        
        viewModel.logout {}
        
        XCTAssertEqual(firebaseAuthManager.invokedSignOutCount, 1)
    }
    
    func test_removePlaylist_InvokesRequiredMethods() {
        XCTAssertFalse(firestoreManager.invokedRemovePlaylist)
        XCTAssertFalse(firestoreManager.invokedGetUserPlaylists)
        XCTAssertFalse(view.invokedUpdateTableView)
  
        viewModel.playlists = [MockData.mockUserPlaylist]
        viewModel.removePlaylist(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(firestoreManager.invokedRemovePlaylistCount, 1)
        XCTAssertEqual(firestoreManager.invokedGetUserPlaylistsCount, 1)
        XCTAssertEqual(view.invokedUpdateTableViewCount, 2)
    }
    
    func test_playListsDidSelectRow_InvokesRequiredMethods() {
        XCTAssertFalse(view.invokedPushVC)
        XCTAssertTrue(view.invokedPushVCParametersList.isEmpty)
        
        viewModel.playlists = [MockData.mockUserPlaylist]
        viewModel.playListsDidSelectRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(view.invokedPushVCCount, 1)
        XCTAssertTrue(view.invokedPushVCParametersList.map(\.vc) is [PlaylistVC])
    }
    
    func test_favoriteListsDidSelectRow_InvokesRequiredMethods() {
        XCTAssertFalse(view.invokedPresentVC)
        XCTAssertTrue(view.invokedPresentVCParametersList.isEmpty)
        
        viewModel.userFavoriteTracks = [MockData.mockTrack]
        viewModel.favoriteListsDidSelectRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(view.invokedPresentVCCount, 1)
        XCTAssertTrue(view.invokedPresentVCParametersList.map(\.vc) is [PlayerVC])
    }       
}
