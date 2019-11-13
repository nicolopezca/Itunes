//
//  DiscografiaViewController.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 08/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell { //cambiar a una clase fuera
    
    @IBOutlet weak var nombreAlbum: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var fechaAlbum: UILabel!
}

class DiscografiaViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    var listasAlbumes: [Album] = []
    var artista: Artist?
    var listaImagenes : [UIImage] = []
    var albumSeleccionado: Album?
    var imagenSeleccionada: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        llenarArray()
        collection.dataSource = self
        collection.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 200)
        collection.collectionViewLayout = layout
    }
    
    func reloadData(json: [String: Any]) {
        let decoder = JSONDecoder()
        do {
            let data =  try JSONSerialization.data(withJSONObject: json["results"], options: JSONSerialization.WritingOptions.prettyPrinted) // convert json to data
            listasAlbumes = try decoder.decode([Album].self, from: data)
            listasAlbumes = listasAlbumes.filter({ $0.collectionName != nil }) //si es nulo no lo inserta
            for i in 0..<listasAlbumes.count{
                let imgUrlStr:String = listasAlbumes[i].artworkUrl100!
                if let imgURL = URL.init(string: imgUrlStr) {
                    do {
                        let imageData = try Data(contentsOf: imgURL as URL);
                        let image = UIImage(data:imageData);
                        listaImagenes.append(image!)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
            }
            self.collection.reloadData()
        } catch {
            print("Error: No es posible cargar el json")
            
        }
    }
    
    func llenarArray(){
        
        var json: [String: Any] = [:]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // create post request
        let url = URL(string: "https://itunes.apple.com/lookup?id=\(artista!.artistId)&entity=album")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                //print(responseJSON)
                json = responseJSON
                DispatchQueue.main.async {
                    self.reloadData(json: json)//llena el array de artistas
                }
            }
        }
        task.resume()
    }
}

extension DiscografiaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listasAlbumes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArtistCollectionViewCell
        cell.nombreAlbum.text = listasAlbumes[indexPath.item].collectionName
        
        cell.fechaAlbum.text = listasAlbumes[indexPath.item].releaseDate
        cell.albumImage.image = listaImagenes[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collection.deselectItem(at: indexPath, animated: true)
        albumSeleccionado = listasAlbumes[indexPath.row]
        imagenSeleccionada = listaImagenes[indexPath.row]
        performSegue(withIdentifier: "ArtistViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ArtistViewController"{
            if let vc: ArtistViewController = (segue.destination as? ArtistViewController){
                vc.album = albumSeleccionado
                vc.imagenCancion = imagenSeleccionada
            }
        }
    }
}



