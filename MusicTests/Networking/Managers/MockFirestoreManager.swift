//
//  MockFirestoreManager.swift
//  MusicTests
//
//  Created by Erislam Nurluyol on 11.12.2023.
//

@testable import Music

final class MockFirestoreManager: FirestoreManagerProtocol {
    
    var invokedGetUserName = false
    var invokedGetUserNameCount = 0
    
    func getUserName(onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void) {
        invokedGetUserName = true
        invokedGetUserNameCount += 1
        onSuccess("Erislam Nurluyol")
    }
    
    var invokedGetUserPlaylist = false
    var invokedGetUserPlaylistCount = 0
    var invokedGetUserPlaylistParameters: (playlist: UserPlaylist, Void)?
    var invokedGetUserPlaylistParametersList = [(playlist: UserPlaylist, Void)]()

    func getUserPlaylist(playlist: UserPlaylist, onSuccess: @escaping ([Music.Track]?) -> (Void), onError: @escaping (String) -> Void) {
        invokedGetUserPlaylist = true
        invokedGetUserPlaylistCount += 1
        invokedGetUserPlaylistParameters = (playlist: playlist, ())
        invokedGetUserPlaylistParametersList.append((playlist: playlist, ()))
        onSuccess([MockData.mockTrack])
    }
    
    var invokedGetUserPlaylists = false
    var invokedGetUserPlaylistsCount = 0
    
    func getUserPlaylists(onSuccess: @escaping ([UserPlaylist]?) -> (Void), onError: @escaping (String) -> Void) {
        invokedGetUserPlaylists = true
        invokedGetUserPlaylistsCount += 1
        onSuccess([MockData.mockUserPlaylist])
    }
    
    var invokedGetUserFavoriteTracks = false
    var invokedGetUserFavoriteTracksCount = 0
    
    func getUserFavoriteTracks(onSuccess: @escaping ([Music.Track]?) -> (Void), onError: @escaping (String) -> Void) {
        invokedGetUserFavoriteTracks = true
        invokedGetUserFavoriteTracksCount += 1
        onSuccess([MockData.mockTrack])
    }
    
    var invokedRemovePlaylist = false
    var invokedRemovePlaylistCount = 0
    var invokedRemovePlaylistParameters: (playlist: UserPlaylist, Void)?
    var invokedRemovePlaylistParametersList = [(playlist: UserPlaylist, Void)]()
    
    func removePlaylist(playlist: UserPlaylist, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedRemovePlaylist = true
        invokedRemovePlaylistCount += 1
        invokedRemovePlaylistParameters = (playlist: playlist, ())
        invokedRemovePlaylistParametersList.append((playlist: playlist, ()))
        onSuccess()
    }
    
    var invokedRemoveTrackFromFavorites = false
    var invokedRemoveTrackFromFavoritesCount = 0
    var invokedRemoveTrackFromFavoritesParameters: (track: Track, Void)?
    var invokedRemoveTrackFromFavoritesParametersList = [(track: Track, Void)]()
    
    func removeTrackFromFavorites(track: Track, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedRemoveTrackFromFavorites = true
        invokedRemoveTrackFromFavoritesCount += 1
        invokedRemoveTrackFromFavoritesParameters = (track: track, ())
        invokedRemoveTrackFromFavoritesParametersList.append((track: track, ()))
        onSuccess()
    }
    
    var invokedCreateNewPlaylist = false
    var invokedCreateNewPlaylistCount = 0
    var invokedCreateNewPlaylistParameters: (playlistName: String, Void)?
    var invokedCreateNewPlaylistParametersList = [(playlistName: String, Void)]()
    
    func createNewPlaylist(playlistName: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedCreateNewPlaylist = true
        invokedCreateNewPlaylistCount += 1
        invokedCreateNewPlaylistParameters = (playlistName: playlistName, ())
        invokedCreateNewPlaylistParametersList.append((playlistName: playlistName, ()))
        onSuccess()
    }
    
    var invokedGetRecentSearches = false
    var invokedGetRecentSearchesCount = 0
    
    func getRecentSearches(onSuccess: @escaping ([String]?) -> (Void), onError: @escaping (String) -> Void) {
        invokedGetRecentSearches = true
        invokedGetRecentSearchesCount += 1
        onSuccess(["Mock Search 1", "Mock Search 2"])
    }
    
    var invokedCheckTrackFavorited = false
    var invokedCheckTrackFavoritedCount = 0
    var invokedCheckTrackFavoritedParameters: (track: Track, Void)?
    var invokedCheckTrackFavoritedParametersList = [(track: Track, Void)]()
    
    func checkTrackFavorited(track: Track, onSuccess: @escaping (Bool) -> Void, onError: @escaping (String) -> Void) {
        invokedCheckTrackFavorited = true
        invokedCheckTrackFavoritedCount += 1
        invokedCheckTrackFavoritedParameters = (track: track, ())
        invokedCheckTrackFavoritedParametersList.append((track: track, ()))
        onSuccess(true)
    }
    
    var invokedUpdateRecentSearches = false
    var invokedUpdateRecentSearchesCount = 0
    var invokedUpdateRecentSearchesParameters: (searchText: String, Void)?
    var invokedUpdateRecentSearchesParametersList = [(searchText: String, Void)]()
    
    func updateRecentSearches(searchText: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedUpdateRecentSearches = true
        invokedUpdateRecentSearchesCount += 1
        invokedUpdateRecentSearchesParameters = (searchText: searchText, ())
        invokedUpdateRecentSearchesParametersList.append((searchText: searchText, ()))
        onSuccess()
    }
    
    var invokedClearRecentSearches = false
    var invokedClearRecentSearchesCount = 0
    
    func clearRecentSearches(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedClearRecentSearches = true
        invokedClearRecentSearchesCount += 1
        onSuccess()
    }
    
    var invokedAddTrackToPlaylist = false
    var invokedAddTrackToPlaylistCount = 0
    var invokedAddTrackToPlaylistParameters: (track: Track, Void)?
    var invokedAddTrackToPlaylistParametersList = [(track: Track, Void)]()
    
    func addTrackToPlaylist(track: Track, playlistID: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedAddTrackToPlaylist = true
        invokedAddTrackToPlaylistCount += 1
        invokedAddTrackToPlaylistParameters = (track: track, ())
        invokedAddTrackToPlaylistParametersList.append((track: track, ()))
        onSuccess()
    }
    
    var invokedRemoveTrackFromPlaylist = false
    var invokedRemoveTrackFromPlaylistCount = 0
    var invokedRemoveTrackFromPlaylistParameters: (track: Track, userPlaylist: UserPlaylist)?
    var invokedRemoveTrackFromPlaylistParametersList = [(track: Track, userPlaylist: UserPlaylist)]()
    
    func removeTrackFromPlaylist(track: Music.Track, userPlaylist: Music.UserPlaylist, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedRemoveTrackFromPlaylist = true
        invokedRemoveTrackFromPlaylistCount += 1
        invokedRemoveTrackFromPlaylistParameters = (track: track, userPlaylist: userPlaylist)
        invokedRemoveTrackFromPlaylistParametersList.append((track: track, userPlaylist: userPlaylist))
        onSuccess()
    }
    
    var invokedAddTrackToFavorites = false
    var invokedAddTrackToFavoritesCount = 0
    var invokedAddTrackToFavoritesParameters: (track: Track, Void)?
    var invokedAddTrackToFavoritesParametersList = [(track: Track, Void)]()
    
    func addTrackToFavorites(track: Music.Track, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedAddTrackToFavorites = true
        invokedAddTrackToFavoritesCount += 1
        invokedAddTrackToFavoritesParameters = (track: track, ())
        invokedAddTrackToFavoritesParametersList.append((track: track, ()))
        onSuccess()
    }
    
    
}
