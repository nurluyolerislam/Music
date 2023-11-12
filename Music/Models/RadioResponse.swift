//
//  RadioResponse.swift
//  Music
//
//  Created by Erislam Nurluyol on 11.11.2023.
//

// MARK: - RadioResponse
struct RadioResponse: Codable {
    let data: [RadioPlaylist]?
}

// MARK: - Datum
struct RadioPlaylist: Codable {
    let id: Int
    let title: String?
    let picture: String?
    let pictureSmall, pictureMedium, pictureBig, pictureXl: String?
    let tracklist: String?
    let md5Image: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id, title, picture
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXl = "picture_xl"
        case tracklist
        case md5Image = "md5_image"
        case type
    }
}
