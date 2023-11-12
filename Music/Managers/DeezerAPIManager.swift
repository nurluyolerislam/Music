//
//  DeezerAPIManager.swift
//  Music
//
//  Created by Erislam Nurluyol on 10.11.2023.
//

class DeezerAPIManager {
    private let baseURL:String = "https://api.deezer.com/"
    
    func getSearchResults(searchText: String, onSuccess: @escaping (SearchTrackResponse?)->(Void), onError: @escaping (String)->(Void)) {
        AlamofireService.shared.fetch(path: baseURL + Endpoint.search.rawValue + searchText) { (response: SearchTrackResponse) in
            onSuccess(response)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func getRadioPlaylists(onSuccess: @escaping (RadioResponse?)->(Void), onError: @escaping (String)->(Void)) {
        AlamofireService.shared.fetch(path: baseURL + Endpoint.radio.rawValue) { (response: RadioResponse) in
            onSuccess(response)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func getRadioPlaylist(playlistURL: String, onSuccess: @escaping (RadioPlaylistResponse?)->(Void), onError: @escaping (String)->(Void)) {
        AlamofireService.shared.fetch(path: playlistURL) { (response: RadioPlaylistResponse) in
            onSuccess(response)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
}

enum Endpoint: String {
    case search = "search/track?q="
    case radio = "radio"
}
