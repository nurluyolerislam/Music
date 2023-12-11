//
//  UserPlaylists.swift
//  Music
//
//  Created by Erislam Nurluyol on 13.11.2023.
//

struct UserPlaylist: Codable {
    let title: String?
    let trackCount: Int?
    let tracks: [Track]?
}
