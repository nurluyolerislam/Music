//
//  MockHomeVC.swift
//  MusicTests
//
//  Created by Yaşar Duman on 11.12.2023.
//

@testable import Music
import UIKit

final class MockHomeVC: HomeVCInterface {
    
    var invokedPrepareTableView = false
    var invokedPrepareTableViewCount = 0
    func prepareTableView() {
        invokedPrepareTableView = true
        invokedPrepareTableViewCount += 1
    }
    
    var invokedprePrepareDiscoverCollectionView = false
    var invokedprePrepareDiscoverCollectionViewCount = 0
    func prepareDiscoverCollectionView() {
        invokedprePrepareDiscoverCollectionView = true
        invokedprePrepareDiscoverCollectionViewCount += 1
    }
    
    var invokedPrepareGenresCollectionView = false
    var invokedPrepareGenresCollectionViewCount = 0
    func prepareGenresCollectionView() {
        invokedPrepareGenresCollectionView = true
        invokedPrepareGenresCollectionViewCount += 1
    }
    
    var invokedAddTargets = false
    var invokedAddTargetsCount = 0
    func addTargets() {
        invokedAddTargets = true
        invokedAddTargetsCount += 1
    }
    
    var invokedConfigureNavigationBar = false
    var invokedConfigureNavigationBarCount = 0
    func configureNavigationBar() {
        invokedConfigureNavigationBar = true
        invokedConfigureNavigationBarCount += 1
    }
    
    var invokedReloadTableView = false
    var invokedReloadTableViewCount = 0
    func reloadTableView() {
        invokedReloadTableView = true
        invokedReloadTableViewCount += 1
    }
    
    var invokedReloadDiscoverCollectionView = false
    var invokedReloadDiscoverCollectionViewCount = 0
    func reloadDiscoverCollectionView() {
        invokedReloadDiscoverCollectionView = true
        invokedReloadDiscoverCollectionViewCount += 1
    }
    
    var invokedReloadGenresCollectionView = false
    var invokedReloadGenresCollectionViewCount = 0
    func reloadGenresCollectionView() {
        invokedReloadGenresCollectionView = true
        invokedReloadGenresCollectionViewCount += 1
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

