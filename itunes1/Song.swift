//
//  Song.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 12/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import Foundation
struct Song: Codable{
    var trackName: String?
    var artistName: String?
    var trackId: Int?
    var collectionId: Int?
    var trackTimeMillis: TimeInterval?
    var artistId : Int?
}
