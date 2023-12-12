//
//  MockSearchVC.swift
//  MusicTests
//
//  Created by Erislam Nurluyol on 11.12.2023.
//

@testable import Music
import UIKit

final class MockSearchVC: SearcVCInterface {
    
    var invokedConfigureNavigationBar = false
    var invokedConfigureNavigationBarCount = 0
    
    func configureNavigationBar() {
        invokedConfigureNavigationBar = false
        invokedConfigureNavigationBarCount += 1
    }
    
    var invokedAddTargets = false
    var invokedAddTargetsCount = 0
    func addTargets() {
        invokedAddTargets = true
        invokedAddTargetsCount += 1
    }
    
    var invokedPrepareRecentSearchesTableView = false
    var invokedPrepareRecentSearchesTableViewCount = 0
    
    func prepareRecentSearchesTableView() {
        invokedPrepareRecentSearchesTableView = true
        invokedPrepareRecentSearchesTableViewCount += 1
    }
    
    var invokedPrepareSearchResultsTableView = false
    var invokedPrepareSearchResultsTableViewCount = 0
    
    func prepareSearchResultsTableView() {
        invokedPrepareSearchResultsTableView = true
        invokedPrepareSearchResultsTableViewCount += 1
    }
    
    var invokedReloadRecentSearchesTableView = false
    var invokedReloadRecentSearchesTableViewCount = 0
    
    func reloadRecentSearchesTableView() {
        invokedReloadRecentSearchesTableView = true
        invokedReloadRecentSearchesTableViewCount += 1
    }
    
    var invokedReloadSearchResultsTableView = false
    var invokedReloadSearchResultsTableViewCount = 0
    
    func reloadSearchResultsTableView() {
        invokedReloadSearchResultsTableView = true
        invokedReloadSearchResultsTableViewCount += 1
    }
    
    var invokedShowRecentSearches = false
    var invokedShowRecentSearchesCount = 0
    
    func showRecentSearches() {
        invokedShowRecentSearches = true
        invokedShowRecentSearchesCount += 1
    }
    
    var invokedShowResults = false
    var invokedShowResultsCount = 0
    
    func showResults() {
        invokedShowResults = true
        invokedShowResultsCount += 1
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
