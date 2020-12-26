//
//  SecondViewController.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 24.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import UIKit
import RealmSwift

class SectionVC: UIViewController {
    var sectionArr: [Section] = []
    var data: Results<DataObjects>!
    var sectionTitle: String = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        data = realm.objects(DataObjects.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        //Цвет фона tableView
        
        self.tableView.backgroundColor = #colorLiteral(red: 0.8979414105, green: 0.8980956078, blue: 0.8979316354, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.8979414105, green: 0.8980956078, blue: 0.8979316354, alpha: 1)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        data = realm.objects(DataObjects.self)
        tableView.reloadData()
        
    }
    
    func capitalizedString(str: String) -> String {
        var specifiedString: String = ""
        let firstIndexOfProble = str.split(separator: " ")[0].lowercased()
        specifiedString = removeToSpecifiedIndex(specifiedString: str)
        specifiedString = specifiedString.lowercased().capitalizingFirstLetter()
        
        let returnString = firstIndexOfProble + " " + specifiedString
        
        if Int(String(returnString.first!)) == nil {
            return str
        }
        
        return returnString
    }
    func removeToSpecifiedIndex(specifiedString: String) -> String {
        var clonString = specifiedString
        let indexOfSpecifiedCharacter = clonString.firstIndex(of: " ")
        clonString.removeSubrange(clonString.startIndex...indexOfSpecifiedCharacter!)
        return clonString
    }
    
    
}
//MARK: - UITableViewDelegate
extension SectionVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.sectionArr[indexPath.section].expanded {
            return 58
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.sectionArr[section].chapters.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPdf" {
            let pdfVC = segue.destination as! PDFVC
            let titlePDf = self.sectionArr[tableView.indexPathForSelectedRow!.section].chapters[tableView.indexPathForSelectedRow!.row].chapter.localized
            
            
            if Int(String(titlePDf.first!)) == nil {
                pdfVC.title = sectionArr[tableView.indexPathForSelectedRow!.section].sectionsName.localized
            } else {
                pdfVC.title = String(capitalizedString(str: titlePDf).split(separator: ".")[0])
            }
            
            let chapter = self.sectionArr[tableView.indexPathForSelectedRow!.section].chapters[tableView.indexPathForSelectedRow!.row].chapter.localized
            
            pdfVC.docName = "\(getCodecsIndex() + 1)Ω\(chapter)"
        }
    }
    
    func getCodecsIndex() -> Int {
        for i in Constants.arrayNamesCode.indices {
            if Constants.arrayNamesCode[i] == sectionTitle {
                return i
            }
        }
        return 0
    }
}

// MARK: - UITableViewDataSource
extension SectionVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath) as! SectionCell
        cell.link = self
       
        let chapters = self.sectionArr[indexPath.section].chapters[indexPath.row]
        cell.nameSectionLabel.text = capitalizedString(str: chapters.chapter.localized)
        
        if cell.checkTheInstanceFromDB() {
            cell.favoriteButton.setImage(UIImage(named: "bookmarkFilled"), for: .normal)
        } else {
            cell.favoriteButton.setImage(UIImage(named: "bookmarkEmpty"), for: .normal)
        }
        
        cell.accessoryView?.tintColor = .white
        
        cell.backgroundColor = .white
        self.tableView.separatorStyle = .none
        
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
        
        header.setup(withTitle: self.sectionArr[section].sectionsName.localized, section: section, delegate: self)
        return header
    }
}

//MARK: - ExpandableHeaderViewDelegate
extension SectionVC: ExpandableHeaderViewDelegate{
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        self.sectionArr[section].expanded = !self.sectionArr[section].expanded
        
        tableView.beginUpdates()
        for row in 0..<self.sectionArr[section].chapters.count{
            print(row)
            tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .fade)
        }
        tableView.endUpdates()
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
