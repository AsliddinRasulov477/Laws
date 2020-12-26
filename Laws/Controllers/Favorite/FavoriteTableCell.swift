//
//  FavoriteTableCell.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 28.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import UIKit

class FavoriteTableCell: UITableViewCell {
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var link: FavoriteVC?
    
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
        layer.cornerRadius = frame.size.height/2
        favoriteLabel.textColor = UIColor(red: 12/255.0, green: 148/255.0, blue: 99/255.0, alpha: 1)
        
        //настройки кнопки favorits
        favoriteButton.setImage(UIImage(named: "bookmarkFilled"), for: .normal)
        
        //при нажатии кнопки вызывается функция handleMarkAsFavorite()
        favoriteButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
    }
    
    @objc func handleMarkAsFavorite(){
        //вызывается метод из класса SectionCell
        do {
            try! realm.write {
                link!.data[favoriteButton.tag].namesBookMarked.remove(at: getRemoveSelectedRow())
                if link!.data[favoriteButton.tag].namesBookMarked.count == 0 {
                    link?.sections = []
                    link?.sectionsIndex = []
                    link!.data = realm.objects(DataObjects.self)
                    for i in link!.data.indices {
                        if link!.data[i].namesBookMarked.count > 0 {
                            link!.sections.append(link!.data[i].nameCodecs)
                            link!.sectionsIndex.append(i)
                        }
                    }
                }
                link?.favoriteTableView.reloadData()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getRemoveSelectedRow() -> Int {
        for i in link!.data[favoriteButton.tag].namesBookMarked.indices {
            if link!.data[favoriteButton.tag].namesBookMarked[i] == favoriteLabel.text {
                return i
            }
        }
        return 0
    }
    
}
