//
//  ArtistCollectionViewCell.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 18/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import Foundation
import UIKit
class ArtistCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageAlbum: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumDate: UILabel!
    func setup(selectedAlbum: Album) {
        guard
            let dateAlbum: String = selectedAlbum.releaseDate
            else {
                return
        }
        let date = convertDate(fecha: dateAlbum)
        self.albumName.text = selectedAlbum.collectionName
        self.albumDate.text = date
        
        guard
        let auxRute: String = selectedAlbum.artworkUrl100
        else {
            return
        }
            loadImage(url: auxRute)
    }
    func convertDate(fecha: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        if let date = dateFormatterGet.date(from: fecha) {
            return dateFormatterPrint.string(from: date)
        } else {
            return ("Error")
        }
    }
    func loadImage(url: String?) {
        guard
            let rute = url
            else {
                return 
        }
        let request = ImageAPI(url: rute )
        request.download { image in
            self.imageAlbum.image = image
        }
    }
}
