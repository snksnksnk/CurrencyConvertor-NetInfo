//
//  OtherExtensions.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 16/04/2022.
//

import Foundation

extension String{
    func localize()->String{
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
