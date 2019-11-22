//
//  DiscografiaViewController.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 08/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import UIKit

class DiscografiaViewController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!
    var albumlList: [Album] = []
    var artist: Artist?
    var selectedAlbum: Album?
    var selectedImage: UIImage?
    @IBOutlet weak var artistName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        artistName.text = artist?.artistName
        loadAlbum()
        collection.dataSource = self
        collection.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 200)
        collection.collectionViewLayout = layout
    }

    func loadAlbum() {
        guard
            let idArtist = artist?.artistId
            else {
                return
        }
        let request = AlbumRequest(idArtista: idArtist )
        request.fetchAlbum { albumListClosure in
            self.albumlList = albumListClosure
            self.collection.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArtistViewController" {
            if let vci: ArtistViewController = (segue.destination as? ArtistViewController) {
                vci.album = selectedAlbum
            }
        }
    }
}

extension DiscografiaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumlList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as? ArtistCollectionViewCell {
            cell.setup(selectedAlbum: albumlList[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collection.deselectItem(at: indexPath, animated: true)
        selectedAlbum = albumlList[indexPath.row]
        performSegue(withIdentifier: "ArtistViewController", sender: self)
    }
}
