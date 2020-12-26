//
//  DetailViewController.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 21.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import UIKit
import PDFKit

class PDFVC: UIViewController, SaveTheMemorySearch {
    
    
    var pdfView = PDFView()
    var docName: String = ""
    var memorySearchText: String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.displayPdf()
    
    }
    
    private func createPdfView(withFrame frame: CGRect) -> PDFView {
        pdfView = PDFView(frame: frame)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        
        return pdfView
    }
    
    private func createPdfDocument(forFileName fileName: String) -> PDFDocument? {
        if let resourceUrl = self.resourceUrl(forFileName: fileName) {
            return PDFDocument(url: resourceUrl)
        }
        
        return nil
    }
    
    private func displayPdf() {
        pdfView = self.createPdfView(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        if let pdfDocument = self.createPdfDocument(forFileName: docName) {
            self.view.insertSubview(pdfView, at: 0)
            pdfView.document = pdfDocument
        }
    }
    
    private func resourceUrl(forFileName fileName: String) -> URL? {
        if let resourceUrl = Bundle.main.url(forResource: fileName,
                                             withExtension: "pdf") {
            return resourceUrl
        }
        
        return nil
    }
    
    @IBAction func searchButtonOnTap(_ sender: UIBarButtonItem) {
        for index in 0..<pdfView.document!.pageCount {
                   let page: PDFPage = pdfView.document!.page(at: index)!
                   let annotations = page.annotations
                   for annotation in annotations {
                       page.removeAnnotation(annotation)
                   }
               }
               
               let vc = storyboard?.instantiateViewController(withIdentifier: "search") as! SearchFromPDFController
               vc.pdfView = pdfView
               vc.searchText = memorySearchText
               vc.theMemorySearchDelegate = self
               present(vc, animated: true, completion: nil)
    }
    
    @objc func hideTabBarOnTapPDFview() {
           
           if tabBarController!.tabBar.isHidden {
               tabBarController?.tabBar.isHidden = false
           } else {
               tabBarController?.tabBar.isHidden = true
           }
           
       }
    
    func saveTheWordWhenCancelPressed(mem: String) {
        memorySearchText = mem
    }
}


protocol SaveTheMemorySearch {
    func saveTheWordWhenCancelPressed(mem: String)
}

