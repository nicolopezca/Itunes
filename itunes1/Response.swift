//
//  ItuneResponse.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 19/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import Foundation

struct SongsResponse: Codable {
    let resultCount: Int
    let results: [Song]
}

struct AlbumResponse: Codable {
    let resultCount: Int
    let results: [Album]
}

struct ArtistsResponse: Codable {
    let resultCount: Int
    let results: [Artist]
}
