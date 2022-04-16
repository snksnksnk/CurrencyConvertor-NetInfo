//
//  CollectionCellTextField.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 15/04/2022.
//

import Foundation
import UIKit

class CollectionCellTextField:UICollectionViewCell{
    @IBOutlet weak var textField: UITextField!
    static let cellIdentifier = "collectionCellTF"
    
    static func nib() -> UINib{
        return UINib(nibName: "CollectionCellTextField", bundle: nil)
    }
    
}
