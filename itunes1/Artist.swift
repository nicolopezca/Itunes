//
//  Artist.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 08/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import Foundation
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


