//
//  SectionCell.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 24.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import UIKit
import RealmSwift

class SectionCell: UITableViewCell {
    
    @IBOutlet weak var nameSectionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var link: SectionVC?
    var data: Results<DataObjects>!
    var indexSectionCell: String = ""
    //Отступ у ячеек
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5
            frame.size.height -= 10
            
            super.frame = frame
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 16
        nameSectionLabel.textColor = UIColor(red: 12/255.0, green: 148/255.0, blue: 99/255.0, alpha: 1)
        data = realm.objects(DataObjects.self)
        
        //настройки кнопки favorits
        favoriteButton.tintColor = .lightGray
        
        //при нажатии кнопки вызывается функция handleMarkAsFavorite()
        favoriteButton.addTarget(self,
                                 action: #selector(saveDataToDB),
                                 for: .touchUpInside)
    }
    
    @objc func saveDataToDB(){
        if checkTheInstanceFromDB() {
            do {
                try! realm.write {
                    
                    data[getCodecsIndex()].namesBookMarked.remove(at: getRemoveSelectedRow())
                    favoriteButton.setImage(UIImage(named: "bookmarkEmpty"), for: .normal)
                    link?.tableView.reloadData()
                }
            }
        } else {
            
            do {
                try realm.write {
                    data[getCodecsIndex()].namesBookMarked.append(nameSectionLabel.text!)
                }
            } catch {
                print(error)
            }
            favoriteButton.setImage(UIImage(named: "bookmarkFilled"), for: .normal)
            
            
        }
    }
    
    func getRemoveSelectedRow() -> Int {
        for i in data[getCodecsIndex()].namesBookMarked.indices {
            if data[getCodecsIndex()].namesBookMarked[i] == nameSectionLabel.text {
                return i
            }
        }
        return 0
    }
    
    func getCodecsIndex() -> Int {
        for i in Constants.arrayNamesCode.indices {
            if Constants.arrayNamesCode[i] == link?.sectionTitle {
                return i
            }
        }
        return 0
    }
    
    func checkTheInstanceFromDB() -> Bool {

        if data[getCodecsIndex()].namesBookMarked.count > 0 {
            for i in data[getCodecsIndex()].namesBookMarked.indices {
                print(data.count)
                if data[getCodecsIndex()].namesBookMarked[i] == nameSectionLabel.text {
                    return true
                }
            }
        }
        
        favoriteButton.setImage(UIImage(named: "bookmarkEmpty"), for: .normal)
        return false
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
