//
//  ViewController.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 05/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var lastWritingTime: Date?
    private var lastWritingText: String?
    var artistList: [Artist] = []
    var selectedArtist: Artist?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatingSearhBar()
        self.tableSettings()
        self.checkTextInSearchBar()
    }
    func loadArtists() {
        let request = ArtistRequest(term: self.searchBar.text?.lowercased() ?? "")
        request.fetchArtist { artits in
            self.artistList = artits
            self.table.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DiscografiaViewController"{
            if let vci: DiscografiaViewController = (segue.destination as? DiscografiaViewController) {
                vci.artist = selectedArtist
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text  = artistList[indexPath.row].artistName
        cell.detailTextLabel?.text = artistList[indexPath.row].primaryGenreName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pos = indexPath.row
        selectedArtist = artistList[pos]
        performSegue(withIdentifier: "DiscografiaViewController", sender: self)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        self.lastWritingText = text
    }
    func checkTextInSearchBar() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            DispatchQueue.main.async {
                guard let lastWritingText = self.lastWritingText,
                    lastWritingText != self.searchBar.text
                    else {
                        return self.checkTextInSearchBar()
                }
                self.lastWritingText = nil
                self.checkTextInSearchBar()
            }
            DispatchQueue.main.async {
                self.loadArtists()
            }
        }
    }
    func creatingSearhBar() {
        self.searchBar.delegate = self
    }
    func tableSettings() {
        self.table.dataSource = self
        self.table.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { return }
        self.lastWritingText = searchText
    }
}
