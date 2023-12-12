//
//  MockProfileVC.swift
//  MusicTests
//
//  Created by Yaşar Duman on 12.12.2023.
//

@testable import Music
import UIKit

final class MockProfileVC: ProfileVCInterface {
    
    var invokedConfigureNavigationBar = false
    var invokedConfigureNavigationBarCount = 0
    func configureNavigationBar() {
        invokedConfigureNavigationBar = true
        invokedConfigureNavigationBarCount += 1
    }
    
    var invokedPrepareTableView = false
    var invokedPrepareTableViewCount = 0
    func prepareTableView() {
        invokedPrepareTableView = true
        invokedPrepareTableViewCount += 1
    }
    
    var invokedAddTargets = false
    var invokedAddTargetsCount = 0
    func addTargets() {
        invokedAddTargets = true
        invokedAddTargetsCount += 1
    }
    
    var invokedUpdateUserPhoto = false
    var invokedUpdateUserPhotoCount = 0
    var invokedUpdateUserPhotoParameters: (url: URL, Void)?
    var invokedUpdateUserPhotoParametersList = [(url: URL, Void)]()
    func updateUserPhoto(imageURL: URL) {
        invokedUpdateUserPhoto = true
        invokedUpdateUserPhotoCount += 1
        invokedUpdateUserPhotoParameters = (url: imageURL, ())
        invokedUpdateUserPhotoParametersList.append((url: imageURL, ()))
    }
    
    var invokedUpdateUserName = false
    var invokedUpdateUserNameCount = 0
    func updateUserName() {
        invokedUpdateUserName = true
        invokedUpdateUserNameCount += 1
    }
    
    var invokedUpdateTableView = false
    var invokedUpdateTableViewCount = 0
    func updateTableView() {
        invokedUpdateTableView = true
        invokedUpdateTableViewCount += 1
    }
    
    var invokedDismissCreatePlaylistPopup = false
    var invokedDismissCreatePlaylistPopupCount = 0
    func dismissCreatePlaylistPopup() {
        invokedDismissCreatePlaylistPopup = true
        invokedDismissCreatePlaylistPopupCount += 1
    }
    
    var invokedShowProgressView = false
    var invokedShowProgressViewCount = 0
    func showProgressView() {
        invokedShowProgressView = true
        invokedShowProgressViewCount += 1
    }
    
    var invokedDismissProgressView = false
    var invokedDismissProgressViewCount = 0
    func dismissProgressView() {
        invokedDismissProgressView = true
        invokedDismissProgressViewCount += 1
    }
    
    var invokedPushVC = false
    var invokedPushVCCount = 0
    var invokedPushVCParameters: (vc: UIViewController, Void)?
    var invokedPushVCParametersList = [(vc: UIViewController, Void)]()
    func pushVC(vc: UIViewController) {
        invokedPushVC = true
        invokedPushVCCount += 1
        invokedPushVCParameters = (vc: vc, ())
        invokedPushVCParametersList.append((vc: vc, ()))
    }
    
    var invokedPresentVC = false
    var invokedPresentVCCount = 0
    var invokedPresentVCParameters: (vc: UIViewController, Void)?
    var invokedPresentVCParametersList = [(vc: UIViewController, Void)]()
    func presentVC(vc: UIViewController) {
        invokedPresentVC = true
        invokedPresentVCCount += 1
        invokedPresentVCParameters = (vc: vc, ())
        invokedPresentVCParametersList.append((vc: vc, ()))
    }
    
    
}
