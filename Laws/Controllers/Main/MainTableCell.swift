//
//  MainCell.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 22.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import UIKit

class MainTableCell: UITableViewCell {
    
    @IBOutlet weak var nameCodeImage: UIImageView!
    @IBOutlet weak var nameCodeLabel: UILabel!
    
    //Отступ у ячеек
    override var frame: CGRect {
        get {
            return super.frame
        }
        
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 0
            frame.size.height -= 10
            
            super.frame = frame
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameCodeLabel.textColor = .black
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 51 / 255.0, green: 196 / 255.0, blue: 129 / 255.0, alpha: 1).cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
