//
//  SearchSongManager.swift
//  Music
//
//  Created by Erislam Nurluyol on 10.11.2023.
//

class SearchSongManager {
    private let service: ServiceProtocol
    private let url:String
    
    init(service: ServiceProtocol) {
        self.service = service
        self.url = "https://api.deezer.com/search/track?q="
    }
    
    func getJsonData(searchText: String, onSuccess: @escaping (SearchTrackResponse?)->(Void), onError: @escaping (String)->(Void)) {
        service.fetch(path: url + searchText) { (response: SearchTrackResponse) in
            onSuccess(response)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
}
