//
//  Tipes.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 21/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import Foundation
struct Song: Codable {
    var trackName: String?
    var artistName: String?
    var trackId: Int?
    var collectionId: Int?
    var trackTimeMillis: TimeInterval?
    var artistId: Int?
}
struct Album: Codable {
    var collectionName: String?
    var releaseDate: String?
    var artworkUrl100: String?
    var collectionId: Int?
    var artistViewUrl: String?
    var collectionPrice: Double?
    var primaryGenreName: String?
}
struct Artist: Codable {
    var wrapperType: String
    var artistType: String
    var artistName: String
    var artistLinkUrl: String
    var artistId: Int
    var amgArtistId: Int?
    var primaryGenreName: String
    var primaryGenreId: Int
}
