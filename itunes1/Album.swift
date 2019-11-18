//
//  Album.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 08/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import Foundation
struct Album: Codable {
    var collectionName: String?
    var releaseDate: String?
    var artworkUrl100: String?
    var collectionId: Int?
    var artistViewUrl: String?
    var collectionPrice: Double?
    var primaryGenreName: String?
}
