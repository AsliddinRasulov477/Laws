//
//  LocalizationSystem.swift
//  MoliyaStudiyasi
//
//  Created by coder on 29/10/20.
//  Copyright © 2020 Luiza. All rights reserved.
//

import Foundation
import UIKit

final class LocalizationSystem {
    static let shared = LocalizationSystem()
    
    private var _bundle: Bundle = .main
    private var _locale = Locale(identifier: "en")

    var locale: Locale {
        get {
            _locale
        } set {
            guard Bundle.main.localizations.contains(newValue.identifier) else { return }
            _locale = newValue
            updateUI()
        }
    }

    var bundle: Bundle {
        _bundle
    }

    private func updateUI() {
        guard
            let path = Bundle.main.path(forResource: _locale.identifier, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else { fatalError() }
        _bundle = bundle
        UserDefaults.standard.setValue(_locale.identifier, forKey: "saveLanguage")
    }
}


extension String {
    var localized: String {
        return NSLocalizedString(self,
                                 tableName: nil,
                                 bundle: LocalizationSystem.shared.bundle,
                                 comment: "")
    }
}

