//
//  ChangeLanguageControllerViewController.swift
//  3003
//
//  Created by Asliddin Rasulov on 24/10/20.
//

import UIKit

class ChangeLanguageController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let langsArray = ["uz-Cyrl", "ru", "uz"]
    let langsCellTitle = ["Узбек тили", "Русский", "O'zbek tili"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = view.frame.height / 17
        tableView.tableFooterView = UIView()
    }

}

extension ChangeLanguageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "langCell", for: indexPath)
        
        if LocalizationSystem.shared.locale == Locale(identifier: langsArray[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        cell.textLabel?.text = langsCellTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LocalizationSystem.shared.locale =
            Bundle.main.localizations.filter { $0 != "Base" }.map { Locale(identifier: $0) }[indexPath.row + 1]
        
        tableView.reloadData()
        title = "til".localized
    
    }
}

