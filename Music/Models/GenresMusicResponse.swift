//
//  GenresMusicResponse.swift
//  Music
//
//  Created by Yaşar Duman on 13.11.2023.
//


// MARK: - GenresMusicResponse
struct GenresMusicResponse: Codable {
    let data: [GenresPlayList]?
}

// MARK: - Datum
struct GenresPlayList: Codable {
    let id: Int?
    let name: String?
    let picture: String?
    let pictureSmall, pictureMedium, pictureBig, pictureXl: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id, name, picture
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXl = "picture_xl"
        case type
    }
}


