//
//  ExpandableHeaderView.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 24.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate{
    //cкрытие и отображение ячеек в секции
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int?
    
    func setup(withTitle title: String, section: Int, delegate: ExpandableHeaderViewDelegate){
        //создаем секцию
        self.delegate = delegate
        self.section = section
        self.textLabel?.text = title
    }
    
    override func layoutSubviews() {
        //внешний вид секции
        super.layoutSubviews()
        
        textLabel?.textColor = .white
        contentView.backgroundColor = UIColor(red: 51 / 255.0, green: 196 / 255.0, blue: 129 / 255.0, alpha: 0.6)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gesterRecognizer: UITapGestureRecognizer){
        
        //раскрытие секции при тапе
        let cell = gesterRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section!)
        
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
