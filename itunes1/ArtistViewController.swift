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
    var listaSongs: [Song] = []
    var imagenCancion: UIImage?
    @IBOutlet weak var tableSongs: UITableView!
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var titleAlbum: UILabel!
    @IBOutlet weak var genreArtist: UILabel!
    @IBOutlet weak var priceAlbum: UILabel!
    
    @IBAction func visitarPagina(_ sender: Any) {
        guard let album = self.album, let artistUrl = album.artistViewUrl, let url = URL(string: artistUrl) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSongs.dataSource = self
        tableSongs.delegate = self
        titleAlbum.text = album?.collectionName
        imageSong.image = imagenCancion
        priceAlbum.text = "\(album!.collectionPrice!)€"
        genreArtist.text = album?.primaryGenreName
        llenarArray()
    }
    
    
    func llenarArray(){
        var json: [String: Any] = [:]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        guard
            let albumId : Int = album?.collectionId
            else{
                return
        }
        guard
        let url = URL(string: "https://itunes.apple.com/lookup?id=\(albumId)&entity=song")
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
                //print(responseJSON)
                json = responseJSON
                DispatchQueue.main.async {
                    self.reloadData(json: json)//llena el array de artistas
                }
            }
        }
        task.resume()
    }
    
    
    func reloadData(json: [String: Any]) {
        
        let decoder = JSONDecoder()
        do {
            let data =  try JSONSerialization.data(withJSONObject: json["results"], options: JSONSerialization.WritingOptions.prettyPrinted) // convert json to data
            
            listaSongs = try decoder.decode([Song].self, from: data)
            listaSongs = listaSongs.filter({ $0.trackName != nil }) //si es nulo no lo inserta
            //listaSongs = listaSongs.sorted(by: {$0.trackName < $1.trackName}) //ordena el array alfabeticamente
            self.tableSongs.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: true)//utiliza el hilo principal
        } catch {
            print("Error: No es posible cargar el json")
        }
    }
}

extension ArtistViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listaSongs.count
    }
    
    /*
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        let h = seconds / 3600000
        var x = seconds - h * 3600000
        let m = x / 60000
        x = x - m * 60000
        let s = x / 1000
        return (h, m, s)
    }
 */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text  = listaSongs[indexPath.row].trackName
        guard
            let milisegundos = listaSongs[indexPath.row].trackTimeMillis
            else{
                print("milisegundos erroneos")
                return cell //triple
        }
        let date = Date(timeIntervalSince1970: milisegundos / 1000)
        var calendar = Calendar.current
         
        guard
            let timeZone = TimeZone(abbreviation: "UTC") // TODO: Remove force unwrap
            else{
                return cell
        }
        calendar.timeZone = timeZone
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        if(hours > 0){
            cell.detailTextLabel?.text = "Duration: \(hours):\(minutes):\(seconds)"
        }
        else if(minutes > 0){
            cell.detailTextLabel?.text = "Duration: \(minutes):\(seconds)"
        }
        else{
            cell.detailTextLabel?.text = "Duration: \(seconds)"

        }
        return cell
    }
    
    
}
