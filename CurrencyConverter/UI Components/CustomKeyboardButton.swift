//
//  CustomKeyboardButton.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 15/04/2022.
//

import Foundation
import UIKit

class CustomKeyboardButton:UICollectionViewCell{
    static let cellIdentifier = "customKeyboardButton"
    static func nib()->UINib{
        return UINib(nibName: "CustomKeyboardButton", bundle: nil)
    }
    
    @IBOutlet weak var cLabel: UILabel!
    
}
