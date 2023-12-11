//
//  MockDeezerAPIManager.swift
//  MusicTests
//
//  Created by Yaşar Duman on 11.12.2023.
//

@testable import Music

final class MockDeezerAPIManager: DeezerAPIManagerProtocol {
    

    var invokedGetSearchResults = false
    var invokedGetSearchResultsCount = 0
    func getSearchResults(searchText: String, onSuccess: @escaping (Music.SearchTrackResponse?) -> (Void), onError: @escaping (String) -> (Void)) {
        invokedGetSearchResults = true
        invokedGetSearchResultsCount += 1
    }
    
    var invokedGetRadioPlaylists = false
    var invokedGetRadioPlaylistsCount = 0
    func getRadioPlaylists(onSuccess: @escaping (Music.RadioResponse?) -> (Void), onError: @escaping (String) -> (Void)) {
        invokedGetRadioPlaylists = true
        invokedGetRadioPlaylistsCount += 1
        
        onSuccess(MockData.mockMusicRadioResponse)
    }
    
    var invokedGetRadioPlaylist = false
    var invokedGetRadioPlaylistCount = 0
    func getRadioPlaylist(playlistURL: String, onSuccess: @escaping (Music.RadioPlaylistResponse?) -> (Void), onError: @escaping (String) -> (Void)) {
        invokedGetRadioPlaylist = true
        invokedGetRadioPlaylistCount += 1
        
        onSuccess(MockData.mockMusicRadioPlaylistResponse)
    }
    
    var invokedGetGenresLists = false
    var invokedGetGenresListsCount = 0
    func getGenresLists(onSuccess: @escaping (Music.GenresMusicResponse?) -> (Void), onError: @escaping (String) -> (Void)) {
        invokedGetGenresLists = true
        invokedGetGenresListsCount += 1
        
        onSuccess(MockData.mockMusicGenresMusicResponse)
    }
    
    var invokedGetGenresListsArtist = false
    var invokedGetGenresListsArtistCount = 0
    func getGenresListsArtist(id: String, onSuccess: @escaping (Music.GenresArtistListsResponse?) -> (Void), onError: @escaping (String) -> (Void)) {
        invokedGetGenresListsArtist = true
        invokedGetGenresListsArtistCount += 1
    } 
}

