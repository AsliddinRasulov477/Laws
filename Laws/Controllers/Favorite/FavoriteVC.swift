//
//  FavouriteViewController.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 21.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteVC: UIViewController {
    var data: Results<DataObjects>!
    var numberOfSection: Int = 0
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var sections: [String] = []
    var sectionsIndex: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = realm.objects(DataObjects.self)
        
        favoriteTableView.separatorStyle = .none
        
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self

        self.favoriteTableView.backgroundColor = #colorLiteral(red: 0.8979414105, green: 0.8980956078, blue: 0.8979316354, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.8979414105, green: 0.8980956078, blue: 0.8979316354, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        data = realm.objects(DataObjects.self)
        
        sections = []
        sectionsIndex = []
        
        for i in data.indices {
            print(data[i].namesBookMarked.count)
            if data[i].namesBookMarked.count > 0 {
                sections.append(data[i].nameCodecs)
                sectionsIndex.append(i)
            }
        }
        
        favoriteTableView.reloadData()
    }
}

//MARK: - UITableViewDelegate
extension FavoriteVC: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(sections)
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(sectionsIndex)
        return data[sectionsIndex[section]].namesBookMarked.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(data[sectionsIndex[section]].nameCodecs)
        return data[sectionsIndex[section]].nameCodecs.localized
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFavoritePdf"{
            let pdfVC = segue.destination as! PDFVC
            pdfVC.title = data[favoriteTableView.indexPathForSelectedRow!.section].namesBookMarked[favoriteTableView.indexPathForSelectedRow!.row]
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoriteVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableCell
        
        cell.link = self
        cell.favoriteLabel.text = data[sectionsIndex[indexPath.section]].namesBookMarked[indexPath.row]
        cell.favoriteButton.tag = sectionsIndex[indexPath.section]
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        tableView.tableFooterView?.backgroundColor = .systemGray
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        
        header.setup(withTitle: data[section].nameCodecs, section: section, delegate: self)
        return header
    }
}

// MARK: - UISearchBarDelegate
extension FavoriteVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        data = data?.filter("nameBookMarked CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "nameBookMarked", ascending: true)
        favoriteTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func loadCategories() {
        data = realm.objects(DataObjects.self).sorted(byKeyPath: "nameBookMarked", ascending: true)
        favoriteTableView.reloadData()
    }
}

extension FavoriteVC: ExpandableHeaderViewDelegate{
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        
        favoriteTableView.beginUpdates()
        for row in 0..<data[section].namesBookMarked.count{
            favoriteTableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .fade)
        }
        favoriteTableView.endUpdates()
    }
    
}
