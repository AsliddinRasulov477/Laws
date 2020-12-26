//
//  Найти_из_PDF.swift
//  3000
//
//  Created by Asliddin Rasulov on 24.09.2020.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit
import PDFKit

class SearchFromPDFController: UIViewController {
    
    var theMemorySearchDelegate: SaveTheMemorySearch!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pdfView = PDFView()
    var searchText: String = ""
    
    var goToResultPage: [PDFPage] = []
    var searchResults: [PDFSelection] = []
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.text = searchText
        searchBar.delegate = self
        searchBar.placeholder = "qidiruv".localized
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
        searchBar.backgroundImage = UIImage()
        searchBar.autocapitalizationType = .none
        searchBar.changeSearchBarColor(color: .white)
        searchBar(searchBar, textDidChange: searchText)

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: false, completion: {
            self.theMemorySearchDelegate.saveTheWordWhenCancelPressed(mem: self.searchBar.text!)
        })
    }
}


//MARK: table
extension SearchFromPDFController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text!
    
        searchForTextSelections(searchText: searchBar.text!, indexAnnotation: 0)
        pdfView.go(to: goToResultPage[0])
        
        dismiss(animated: false, completion: {
            self.theMemorySearchDelegate.saveTheWordWhenCancelPressed(mem: self.searchBar.text!)
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultSearchCell
    
        let selection = searchResults[indexPath.row]
        selection.extendForLineBoundaries()
        
        cell.searchTextLabel.text = searchBar.text!
    
        cell.infoSearchLabel.attributedText = selection.attributedString?.replacing(placeholder: searchBar.text!, with: selection.string!)
        
        cell.numberOfPage?.text = "\(pdfView.document!.index(for: selection.pages.first!) + 1)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.searchText = searchBar.text!
    
        searchForTextSelections(searchText: searchBar.text!, indexAnnotation: indexPath.row)
        pdfView.go(to: goToResultPage[indexPath.row])
        
        dismiss(animated: false, completion: {
            self.theMemorySearchDelegate.saveTheWordWhenCancelPressed(mem: self.searchBar.text!)
        })
    }
    
    
}

//MARK: ResultSearchCell
class ResultSearchCell: UITableViewCell {
    @IBOutlet weak var searchTextLabel: UILabel!
    @IBOutlet weak var infoSearchLabel: UILabel!
    @IBOutlet weak var numberOfPage: UILabel!
}


//MARK: search
extension SearchFromPDFController: UISearchBarDelegate, PDFDocumentDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        goToResultPage.removeAll()
        tableView.reloadData()
        pdfView.document!.delegate = self
        pdfView.document!.cancelFindString()
        pdfView.document!.beginFindString(searchText, withOptions: .caseInsensitive)
    }
    
    func didMatchString(_ instance: PDFSelection) {
       
        searchResults.append(instance)
        goToResultPage.append(instance.pages.last!)
        tableView.reloadData()
    }

    
    func searchForTextSelections(searchText: String, indexAnnotation: Int) {
        var findStringIndex: Int = 0
        let selections = pdfView.document!.findString(searchText.lowercased(), withOptions: .caseInsensitive)
        
        selections.forEach { selection in
            selection.pages.forEach { page in
                findStringIndex += 1
                let textSelections = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
                textSelections.endLineStyle = .square
                if indexAnnotation + 1 == findStringIndex {
                    textSelections.color = UIColor.orange.withAlphaComponent(0.5)
                } else {
                    textSelections.color = UIColor.yellow.withAlphaComponent(0.5)
                }
                page.addAnnotation(textSelections)
                goToResultPage.append(page)
            }
        }
    }
}
extension NSAttributedString {
    func replacing(placeholder:String, with valueString:String) -> NSAttributedString {

        if let range = self.string.range(of: placeholder) {
            let nsRange = NSRange(range, in: valueString)
            let mutableText = NSMutableAttributedString(attributedString: self)
            mutableText.replaceCharacters(in: nsRange, with: valueString)
            return mutableText as NSAttributedString
        }
        return self
    }
}
extension UISearchBar {
    
    func changeSearchBarColor(color: UIColor) {
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 35)
        UIGraphicsBeginImageContext(frame.size)
        color.setFill()
        UIBezierPath(rect: frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.setSearchFieldBackgroundImage(makeRoundedImage(image: bgImage, radius: 15), for: .normal)
    }
    
    func makeRoundedImage(image: UIImage, radius: Float) -> UIImage {
        let imageLayer: CALayer = CALayer()
        imageLayer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        imageLayer.contents = (image.cgImage as AnyObject)
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = 10
        UIGraphicsBeginImageContext(image.size)
        imageLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return roundedImage
    }
}
