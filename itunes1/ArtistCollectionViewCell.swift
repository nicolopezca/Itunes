//
//  ArtistCollectionViewCell.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 18/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import Foundation
import UIKit
class ArtistCollectionViewCell: UICollectionViewCell { //cambiar a una clase fuera
    @IBOutlet weak var nombreAlbum: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var fechaAlbum: UILabel!
    func setup(selectedAlbum: Album, cellAlbum: ArtistCollectionViewCell) -> ArtistCollectionViewCell? {
        guard
            let dateAlbum: String = selectedAlbum.releaseDate
            else {
                return nil
        }
        let date = convertDate(fecha: dateAlbum)
        cellAlbum.nombreAlbum.text = selectedAlbum.collectionName
        cellAlbum.fechaAlbum.text = date
        guard
        let auxRute: String = selectedAlbum.artworkUrl100
        else {
            return nil
        }
        guard
            let image: UIImage = loadImage(url: auxRute)
            else {
                return nil
        }
        cellAlbum.albumImage.image = image
        return cellAlbum
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
    func loadImage(url: String) -> UIImage? {
        if let imgUrlStr: String = url {
            if let imgURL = URL.init(string: imgUrlStr) {
                do {
                    let imageData = try Data(contentsOf: imgURL as URL)
                    if let image = UIImage(data: imageData) {
                        return image
                    }
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
        }
        return nil
    }
}
