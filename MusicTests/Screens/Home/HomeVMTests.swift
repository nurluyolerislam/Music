//
//  HomeVMTests.swift
//  MusicTests
//
//  Created by Yaşar Duman on 11.12.2023.
//

import XCTest
@testable import Music

final class HomeVMTests: XCTestCase {
    private var viewModel: HomeViewModel!
    private var view: MockHomeVC!
    private var manager: MockDeezerAPIManager!
    
    
    override func setUp() {
        super.setUp()
        view = .init()
        manager = .init()
        viewModel = .init(manager: manager, view: view)
        
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        manager = nil
        viewModel = nil
    }
    
    func test_viewDidLoad_InvokesRequiredMethods() {
        //given
        XCTAssertEqual(view.invokedPrepareTableViewCount, 0)
        XCTAssertEqual(view.invokedprePrepareDiscoverCollectionViewCount, 0)
        XCTAssertEqual(view.invokedPrepareGenresCollectionViewCount, 0)
        XCTAssertEqual(view.invokedAddTargetsCount, 0)
        XCTAssertEqual(view.invokedConfigureNavigationBarCount, 0)
        XCTAssertEqual(manager.invokedGetRadioPlaylistsCount, 0)
        XCTAssertEqual(view.invokedReloadDiscoverCollectionViewCount, 0)
        XCTAssertEqual(manager.invokedGetRadioPlaylistCount, 0)
        XCTAssertEqual(view.invokedReloadTableViewCount, 0)
        XCTAssertEqual(view.invokedShowProgressViewCount, 0)
        XCTAssertEqual(manager.invokedGetGenresListsCount, 0)
        
        //when
        viewModel.viewDidLoad()
        
        //then
        XCTAssertEqual(view.invokedPrepareTableViewCount, 1)
        XCTAssertEqual(view.invokedprePrepareDiscoverCollectionViewCount, 1)
        XCTAssertEqual(view.invokedPrepareGenresCollectionViewCount, 1)
        XCTAssertEqual(view.invokedAddTargetsCount, 1)
        XCTAssertEqual(view.invokedConfigureNavigationBarCount, 1)
        XCTAssertEqual(manager.invokedGetRadioPlaylistsCount, 1)
        XCTAssertEqual(view.invokedReloadDiscoverCollectionViewCount, 1)
        XCTAssertEqual(manager.invokedGetRadioPlaylistCount, 1)
        XCTAssertEqual(view.invokedReloadTableViewCount, 1)
        XCTAssertEqual(view.invokedShowProgressViewCount, 1)
        XCTAssertEqual(manager.invokedGetGenresListsCount, 1)
    }
    
    
    func test_tableViewCellForItem_ReturnTrack() {
        XCTAssertNil(viewModel.popularSongsResponse?.data)
        
        viewModel.viewDidLoad()
        sleep(5)
        viewModel.tableViewCellForItem(at: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(viewModel.popularSongsResponse?.data)
    }
    
    func test_discoverCollectionViewCellForItem_ReturnPlayList() {
        XCTAssertNil(viewModel.radioResponse?.data)
        
        viewModel.viewDidLoad()
        sleep(5)
        viewModel.discoverCollectionViewCellForItem(at: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(viewModel.radioResponse?.data)
    }
    
    func test_genresCollectionViewCellForItem_ReturnGenresPlayList() {
        XCTAssertNil(viewModel.genresResponse?.data)
        
        viewModel.viewDidLoad()
        sleep(5)
        viewModel.genresCollectionViewCellForItem(at: IndexPath(item: 0, section: 0))
        
        XCTAssertNotNil(viewModel.genresResponse?.data)
    }
    
    func test_discoverCollectionDidSelectItem_ReturnPlayList() {
        XCTAssertNil(viewModel.radioResponse?.data)
        XCTAssertFalse(view.invokedPushVC)
        
        viewModel.viewDidLoad()
        viewModel.discoverCollectionDidSelectItem(at: IndexPath(item: 0, section: 0))
        
        XCTAssertNotNil(viewModel.radioResponse?.data)
        XCTAssertTrue(view.invokedPushVC)
    }

    func test_genresCollectionDidSelectItem_ReturnGenreArtistList() {
        XCTAssertNil(viewModel.genresResponse?.data)
        XCTAssertFalse(view.invokedPushVC)
        
        viewModel.viewDidLoad()
        sleep(5)
        viewModel.genresCollectionDidSelectItem(at: IndexPath(item: 0, section: 0))
        
        XCTAssertNotNil(viewModel.genresResponse?.data)
        XCTAssertTrue(view.invokedPushVC)
    }
    
    
    func test_popularSongsDidSelectItem_ReturnsSongs() {
        XCTAssertNil(viewModel.popularSongsResponse?.data)
        XCTAssertFalse(view.invokedPresentVC)
        
        viewModel.viewDidLoad()
        sleep(5)
        viewModel.popularSongsDidSelectItem(at: IndexPath(row: 0, section: 0))
    
        XCTAssertNotNil(viewModel.popularSongsResponse?.data)
        XCTAssertTrue(view.invokedPresentVC)
    }
    
    func test_discoverVCnumberOfItemsInSection_ReturnsPlayListCount() {
        XCTAssertNil(viewModel.radioResponse?.data)
        
        viewModel.viewDidLoad()
        viewModel.discoverVCnumberOfItemsInSection()
        
        XCTAssertNotNil(viewModel.radioResponse?.data)
    }
    
    
    func test_DiscoverVCDidSelectItem_ReturnTarckLists() {
        XCTAssertNil(viewModel.radioResponse?.data)
        XCTAssertFalse(view.invokedPushVC)
        
        viewModel.viewDidLoad()
        viewModel.DiscoverVCDidSelectItem(at: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(viewModel.radioResponse?.data)
        XCTAssertTrue(view.invokedPushVC)
    }
    
    func test_genresVCnumberOfItemsInSection_ReturnGenresResponseCount() {
        XCTAssertNil(viewModel.genresResponse?.data)
        
        viewModel.viewDidLoad()
        sleep(5)
        viewModel.genresVCnumberOfItemsInSection()
        
        XCTAssertNotNil(viewModel.genresResponse?.data)
    }
    
    func test_GenresVCDidSelectItem_ReturnGenreArtistDetail() {
        XCTAssertNil(viewModel.genresResponse?.data)
        XCTAssertFalse(view.invokedPushVC)
        
        viewModel.viewDidLoad()
        sleep(5)
        viewModel.GenresVCDidSelectItem(at: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(viewModel.genresResponse?.data)
        XCTAssertTrue(view.invokedPushVC)
    }
}
