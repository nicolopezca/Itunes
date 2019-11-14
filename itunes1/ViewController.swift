//
//  ViewController.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 05/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController{
    
    @IBOutlet weak var tabla: UITableView!
    var listaArtistasSeleccionados :[Artist] = []
    var resultsController = UITableViewController()
    var searchController : UISearchController!
    private var lastWritingTime: Date?
    private var lastWritingText: String?
    var listaArtistas :[Artist] = []
    var artistaSeleccionado : Artist?
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatingSearhBar()//crear search bar
        self.tableSettings() //crear table view
        //self.checkTimeInSearchBar()
        self.checkTextInSearchBar()
    }
    
    func reloadData(json: [String: Any]) {
        let decoder = JSONDecoder()
        do {
            let data =  try JSONSerialization.data(withJSONObject: json["results"], options: JSONSerialization.WritingOptions.prettyPrinted) // convert json to data
            
            listaArtistas = try decoder.decode([Artist].self, from: data)
            listaArtistas = listaArtistas.sorted(by: {$0.artistName < $1.artistName}) //ordena el array alfabeticamente
            // self.tabla.reloadData()
            self.tabla.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)//utiliza el hilo principal
            //}
        } catch {
            print("Error: No es posible cargar el json")
            
        }
    }
    
    func loadArtists() {
        var json: [String: Any] = [:]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        guard
            let term = self.searchController.searchBar.text?.lowercased(),
            let urlString = "https://itunes.apple.com/search?media=music&entity=musicArtist&term=\(term)&limit=10&offset=0&lang=en"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString)
            else {
                print("La url no es valida")
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
                self.reloadData(json: json)//llena el array de artistas
                
                //PONER AQUI LOS DOS SEGUNDOS
                OperationQueue.main.addOperation ({
                    self.resultsController.tableView.reloadData()
                })
            }
        }
        task.resume()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listaArtistas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text  = listaArtistas[indexPath.row].artistName
        cell.detailTextLabel?.text = listaArtistas[indexPath.row].primaryGenreName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pos = indexPath.row
        artistaSeleccionado = listaArtistas[pos]
        performSegue(withIdentifier: "DiscografiaViewController", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "DiscografiaViewController"{
            if let vc: DiscografiaViewController = (segue.destination as? DiscografiaViewController){
                vc.artista = artistaSeleccionado
            }
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        //self.lastWritingTime = Date()
        self.lastWritingText = text
    }
    
    //Esta funcion se llama cada dos segundos comprobando si han pasado dos segundos desde la ultima vez que has escrito.
    //La fecha de la ultima vez que has escrito es lastWrittingTime, la fercha actual es Date()
    /*
    func checkTimeInSearchBar() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            guard let lastWritingTime = self.lastWritingTime, lastWritingTime.addingTimeInterval(2) > Date() else { return self.checkTimeInSearchBar() }
            self.lastWritingTime = nil
            self.checkTimeInSearchBar()
            DispatchQueue.main.async {
                self.loadArtists()
            }
        }
    }
    */
    
    //esta funcion comprueba si el texto ha cambiado desde hace dos segundos
    func checkTextInSearchBar() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            DispatchQueue.main.async {
            guard let lastWritingText = self.lastWritingText, lastWritingText != self.searchController.searchBar.text else { return self.checkTextInSearchBar() }
            self.lastWritingText = nil
            self.checkTextInSearchBar()
            }
            DispatchQueue.main.async {
                self.loadArtists()
            }
        }
    }
    
    
    func creatingSearhBar() {
        //1
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        //2
        self.tabla.tableHeaderView = self.searchController.searchBar
        //3
        self.searchController.searchResultsUpdater = self
    }
    
    func tableSettings() {
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
    }
    
}
