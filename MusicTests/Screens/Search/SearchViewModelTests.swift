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
}
