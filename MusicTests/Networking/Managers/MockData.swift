//
//  MockData.swift
//  MusicTests
//
//  Created by Yaşar Duman on 11.12.2023.
//

import Foundation
@testable import Music

struct MockData {
    static let  mockMusicRadioResponse: Music.RadioResponse = {
        
        return Music.RadioResponse (data: [mockPlayList])
    }()
    
    static let  mockMusicRadioPlaylistResponse: Music.RadioPlaylistResponse = {
        
        return Music.RadioPlaylistResponse (data: [mockTrack])
    }()
    
    static let  mockMusicGenresMusicResponse: Music.GenresMusicResponse = {
        
        return Music.GenresMusicResponse (data: [mockGenresPlayList])
    }()
    
    static let  mockSearchTrackResponse: Music.SearchTrackResponse = {
        
        return Music.SearchTrackResponse (data: [mockTrack],
                                          total: 10)
    }()
    
    static let mockUserPlaylist: Music.UserPlaylist = {
        .init(title: "Mock Playlist",
              trackCount: 1,
              tracks: [mockTrack])
    }()
    
    static let mockPlayList: Music.Playlist = {
        return Music.Playlist(id: 1,
                              title: "",
                              picture: "",
                              pictureSmall: "",
                              pictureMedium: "",
                              pictureBig: "",
                              pictureXl: "",
                              tracklist: "",
                              md5Image: "",
                              type: "")
    }()
    
    static let mockTrack: Music.Track = {
        return Music.Track(id: 1,
                           readable: true,
                           title: "",
                           titleShort: "",
                           link: "",
                           duration: 0,
                           rank: 0,
                           explicitLyrics: true,
                           explicitContentLyrics: 0,
                           explicitContentCover: 0,
                           preview: "",
                           md5Image: "",
                           artist: mockArtist,
                           album: mockAlbum,
                           type: "")
    }()
    
    static let mockArtist: Music.Artist = {
        return Music.Artist(id: 0,
                            name: "",
                            link: "",
                            picture: "",
                            pictureSmall: "",
                            pictureMedium: "",
                            pictureBig: "",
                            pictureXl: "",
                            tracklist: "",
                            type: "")
    }()
    
    static let mockAlbum: Music.Album = {
        return Music.Album(id: 1,
                           title: "",
                           cover: "",
                           coverSmall: "",
                           coverMedium: "",
                           coverBig: "", 
                           coverXl: "",
                           md5Image: "",
                           tracklist: "",
                           type: "")
    }()
    
    static let mockGenresPlayList: Music.GenresPlayList = {
        return Music.GenresPlayList(id: 0,
                                    name: "",
                                    picture: "",
                                    pictureSmall: "",
                                    pictureMedium: "",
                                    pictureBig: "",
                                    pictureXl: "",
                                    type: "")
    }()
    
    static let mockURL: URL = {
        return URL(string: "https://image.tmdb.org/t/p/w500/18IsRVfs5MkkTcqTGlUAnka6sCh.jpg")
    }()!
    
}
