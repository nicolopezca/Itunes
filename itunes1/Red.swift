//
//  red.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 20/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import Foundation
import UIKit

//class searchController: UISearchBar {
//
//    }
class API {
    let url: String
    init(url: String) {
        self.url = url
    }
    func performRequest(_ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: self.url) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

class ArtistRequest {
    let api: API
    init(term: String) {
        self.api = API(url: "https://itunes.apple.com/search?media=music&entity=musicArtist&term=\(term)&limit=10&offset=0&lang=en")
    }
    func fetchArtist(_ completion: @escaping ([Artist]) -> Void) {
        var artits: [Artist] = []
        api.performRequest { data, response, _ in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ArtistsResponse.self, from: data)
                artits = response.results.filter({ $0.artistName != nil })
                artits = artits.sorted(by: {$0.artistName < $1.artistName})
            } catch let err {
                print("Err", err)
            }
            DispatchQueue.main.async {
                completion(artits)
            }
        }
    }
}

class AlbumRequest {
    let api: API
    init(idArtista: Int) {
        self.api = API(url: "https://itunes.apple.com/lookup?id=\(idArtista)&entity=album")
    }
    func fetchAlbum(_ completion: @escaping ([Album]) -> Void) {
        var albumlList: [Album] = []
        api.performRequest { data, response, _ in
            guard let data = data else { return }
            do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(AlbumResponse.self, from: data)
            albumlList = response.results.filter({ $0.collectionName != nil })
            } catch let err {
                print("Err", err)
            }
            DispatchQueue.main.async {
                completion(albumlList)
            }
        }
    }
}

class SongRequest {
    let api: API
    init(albumId: Int) {
        self.api = API(url: "https://itunes.apple.com/lookup?id=\(albumId)&entity=song")
    }
    func fetchSong(_ completion: @escaping ([Song]) -> Void) {
        var songlList: [Song] = []
        api.performRequest { data, response, _ in
            guard let data = data else { return }
            do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(SongsResponse.self, from: data)
            songlList = response.results.filter({ $0.trackName != nil })
            } catch let err {
                print("Err", err)
            }
            DispatchQueue.main.async {
                completion(songlList)
            }
        }
    }
}
