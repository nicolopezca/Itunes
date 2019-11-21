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

        /*
        guard
            let idArtista: Int = artist?.artistId
            else {
                return
        }
        guard
            let url = URL(string: "https://itunes.apple.com/lookup?id=\(idArtista)&entity=album")
            else
        {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(AlbumResponse.self, from: data)
                self.albumlList = response.results.filter({ $0.collectionName != nil })
                /*
                for cont in 0..<self.albumlList.count {
                    guard
                        let imgUrlStr: String = self.albumlList[cont].artworkUrl100
                        else {
                            return
                    }
                    if let imgURL = URL.init(string: imgUrlStr) {
                        do {
                            let imageData = try Data(contentsOf: imgURL as URL)
                            guard
                                let image = UIImage(data: imageData)
                                else {
                                    return
                            }
                            self.imageList.append(image)
                        } catch {
                            print("Unable to load data: \(error)")
                        }
                    }
                }
                */
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
            */
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArtistViewController" {
            if let vci: ArtistViewController = (segue.destination as? ArtistViewController) {
                vci.album = selectedAlbum
                vci.imagenCancion = selectedImage
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
            let set = ArtistCollectionViewCell()
            //YA NO HAGO NADA CON CELL, DEBERIA HACERLO
            set.setup(selectedAlbum: albumlList[indexPath.item], cellAlbum: cell)
            return cell
            /*
            guard
                let dateAlbum: String = albumlList[indexPath.item].releaseDate
                else {
                    return cell
            }
            let date = convertDate(fecha: dateAlbum)
            cell.nombreAlbum.text = albumlList[indexPath.item].collectionName
            cell.fechaAlbum.text = date
            guard
            let auxRute: String = albumlList[indexPath.item].artworkUrl100
            else {
                return cell
            }
            guard
                let image: UIImage = loadImage(url: auxRute)
                else {
                    return cell
            }
            cell.albumImage.image = image
            return cell
 */
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collection.deselectItem(at: indexPath, animated: true)
        selectedAlbum = albumlList[indexPath.row]
        guard
        let auxRute: String = albumlList[indexPath.row].artworkUrl100
        else {
            return
        }
        guard
            let image: UIImage = loadImage(url: auxRute)
            else {
                return
        }
        selectedImage = image
        performSegue(withIdentifier: "ArtistViewController", sender: self)
    }

}
