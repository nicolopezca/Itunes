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
                guard
                    let imgUrlStr:String = listasAlbumes[i].artworkUrl100
                    else{
                        return
                }
                if let imgURL = URL.init(string: imgUrlStr) {
                    do {
                        let imageData = try Data(contentsOf: imgURL as URL);
                        guard
                        let image = UIImage(data:imageData)
                            else{
                                return
                        }
                        listaImagenes.append(image)

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
        
        guard
            let idArtista: Int = artista?.artistId
            else{
                return
        }
        guard
        let url = URL(string: "https://itunes.apple.com/lookup?id=\(idArtista)&entity=album")
            else{
                return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ArtistCollectionViewCell{
            guard
                let dateAlbum: String = listasAlbumes[indexPath.item].releaseDate
                else{
                    return cell
            }
            let date = convertDate(fecha: dateAlbum)

        cell.nombreAlbum.text = listasAlbumes[indexPath.item].collectionName
        cell.fechaAlbum.text = date
        cell.albumImage.image = listaImagenes[indexPath.item]
        return cell
        }
        else{ //triple
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
        }

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
    
    func convertDate(fecha: String)->String{
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
}



