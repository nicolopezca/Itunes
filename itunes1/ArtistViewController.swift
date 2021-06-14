//
//  ArtistViewController.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 12/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController {
    var album: Album?
    var songList: [Song] = []
    var songImage: UIImage?
    @IBOutlet weak var tableSongs: UITableView!
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var titleAlbum: UILabel!
    @IBOutlet weak var vSpinner: UIActivityIndicatorView!
    @IBOutlet weak var genreArtist: UILabel!
    @IBOutlet weak var priceAlbum: UILabel!
    @IBAction func visitPage(_ sender: Any) {
        guard let album = self.album, let artistUrl = album.artistViewUrl, let url = URL(string: artistUrl)
            else {
                return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    override func viewDidLoad() {
        vSpinner.hidesWhenStopped = true
        vSpinner.style = UIActivityIndicatorView.Style.medium
        self.view.addSubview(vSpinner)
        super.viewDidLoad()
        tableSongs.dataSource = self
        tableSongs.delegate = self
        titleAlbum.text = album?.collectionName
        imageSong.image = songImage
        loadImage(url: album?.artworkUrl100)
        guard
            let aux: Double = album?.collectionPrice
            else {
                return
        }
        priceAlbum.text = "\(aux)€"
        genreArtist.text = album?.primaryGenreName
        loadSongs()
    }
    func loadImage(url: String?) {
        guard
            let rute = url
            else {
                return
        }
        vSpinner.startAnimating()
        let request = ImageAPI(url: rute )
        request.download { image in
            self.vSpinner.stopAnimating()
            self.imageSong.image = image
        }
    }
    func loadSongs() {
        guard
            let idAlbum = album?.collectionId
            else {
                return
        }
        let request = SongRequest(albumId: idAlbum)
        request.fetchSong { songListClosure in
            self.songList = songListClosure
            self.tableSongs.reloadData()
        }
    }
}

extension ArtistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text  = songList[indexPath.row].trackName
        guard
            let milisegundos = songList[indexPath.row].trackTimeMillis
            else {
                print("milisegundos erroneos")
                return cell
        }
        let date = Date(timeIntervalSince1970: milisegundos / 1000)
        var calendar = Calendar.current
        guard
            let timeZone = TimeZone(abbreviation: "UTC")
            else {
                return cell
        }
        calendar.timeZone = timeZone
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        if hours > 0 {
            cell.detailTextLabel?.text = "Duration: \(hours):\(minutes):\(seconds)"
        } else if minutes > 0 {
            cell.detailTextLabel?.text = "Duration: \(minutes):\(seconds)"
        } else {
            cell.detailTextLabel?.text = "Duration: \(seconds)"
        }
        return cell
    }
}
