//
//  MainViewController.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 21.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableVC: UIViewController {
    var allConstantsArr: [[Section]] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    var data: Results<DataObjects>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(DataObjects.self)
        
        if data.count == 0 {
            for i in Constants.arrayNamesCode.indices {
                let newData = DataObjects()
                newData.nameCodecs = Constants.arrayNamesCode[i]
                saveChapters(data: newData)
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        self.tableView.rowHeight = self.view.frame.size.height/2
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allConstantsArr = []
        self.allConstantsArr.append(Constants.sectionsForAdminCode)
        self.allConstantsArr.append(Constants.sectionsForFamilyCode)
        self.allConstantsArr.append(Constants.sectionsForNalogCode)
        self.allConstantsArr.append(Constants.sectionsForTrudCode)
        self.allConstantsArr.append(Constants.sectionsForGrajdanskiyCode)
        self.allConstantsArr.append(Constants.sectionsForUgolovCode)
//        self.allConstantsArr.append(Constants.sectionsForUgolovCodeOsob)
        self.allConstantsArr.append(Constants.sectionsForUgolovProcessCode)
        self.allConstantsArr.append(Constants.sectionsForTamojCode)
        self.allConstantsArr.append(Constants.sectionsForObshestvoCode)
        self.allConstantsArr.append(Constants.sectionsForZemelniyCode)
        self.allConstantsArr.append(Constants.sectionsForBudgetCode)
        self.allConstantsArr.append(Constants.sectionsForChastniyCode)
        
        print(allConstantsArr)
    }
    
    func saveChapters(data: DataObjects) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
    }
    
}

// MARK: - UITableViewDelegate
extension MainTableVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSections"{
            let detailVC = segue.destination as! SectionVC
            //Передаем название в следующий контроллер
            detailVC.sectionTitle = Constants.arrayNamesCode[tableView.indexPathForSelectedRow!.row]
            detailVC.title = Constants.arrayNamesCode[tableView.indexPathForSelectedRow!.row].localized
            detailVC.sectionArr = self.allConstantsArr[tableView.indexPathForSelectedRow!.row]
            print(detailVC.title!)
        }
    }
}

// MARK: - UITableViewDataSource
extension MainTableVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Constants.arrayNamesCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableCell", for: indexPath) as! MainTableCell
        
        cell.nameCodeLabel.text = Constants.arrayNamesCode[indexPath.row].localized
        cell.nameCodeImage.image = UIImage(named: Constants.arrayNamesCode[indexPath.row])
        cell.backgroundColor = .white
        
        self.tableView.separatorStyle = .none
        
        //Анимация ячеек
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, animations: { cell.alpha = 1 })
        
        return cell
    }
}
