//
//  SearchViewModelTests.swift
//  MusicTests
//
//  Created by Erislam Nurluyol on 11.12.2023.
//

import XCTest
@testable import Music

final class SearchViewModelTests: XCTestCase {
    private var viewModel: SearchViewModel!
    private var view: MockSearchVC!
    private var deezerAPIManager: MockDeezerAPIManager!
    private var firestoreManager: MockFirestoreManager!
    
    override func setUp() {
        super.setUp()
        view = .init()
        deezerAPIManager = .init()
        firestoreManager = .init()
        viewModel = .init(view: view, deezerAPIManager: deezerAPIManager, firestoreManager: firestoreManager)
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        deezerAPIManager = nil
        firestoreManager = nil
        viewModel = nil
    }
    
    func test_loadView_invokesRequiredMethods() {
        XCTAssertFalse(view.invokedShowRecentSearches)
        
        viewModel.loadView()
        
        XCTAssertEqual(view.invokedShowRecentSearchesCount, 1)
    }
    
    func test_viewDidLoad_invokesRequiredMethods() {
        XCTAssertFalse(view.invokedConfigureNavigationBar)
        XCTAssertFalse(view.invokedPrepareRecentSearchesTableView)
        XCTAssertFalse(view.invokedPrepareSearchResultsTableView)
        XCTAssertFalse(view.invokedAddTargets)
        
        viewModel.viewDidLoad()
        
        XCTAssertEqual(view.invokedConfigureNavigationBarCount, 1)
        XCTAssertEqual(view.invokedPrepareRecentSearchesTableViewCount, 1)
        XCTAssertEqual(view.invokedPrepareSearchResultsTableViewCount, 1)
        XCTAssertEqual(view.invokedAddTargetsCount, 1)
    }
    
    func test_viewDidAppear_invokesRequiredMethods() {
        XCTAssertFalse(firestoreManager.invokedGetRecentSearches)
        XCTAssertFalse(view.invokedReloadRecentSearchesTableView)
        
        viewModel.viewDidAppear()
        
        XCTAssertEqual(firestoreManager.invokedGetRecentSearchesCount, 1)
        XCTAssertEqual(view.invokedReloadRecentSearchesTableViewCount, 1)
    }
}
