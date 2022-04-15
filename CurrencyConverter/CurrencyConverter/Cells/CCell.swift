//
//  Cell.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 15/04/2022.
//

import Foundation
import UIKit

class CCell:UITableViewCell{
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static let cellIdentifier = "ce"
    static func nib()->UINib{
        return UINib(nibName: "CCell", bundle: nil)
    }
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    var selectedCurrency:APIManager.ExchangeRate!
    
    func setupCell(rate:APIManager.ExchangeRate){
        titleL.text = rate.currency
        
        ImageManager.shared.getCountryImage(url: rate.imgURL, customSize: .zero, completion: { [self] image, error in
            if error != nil{
                print(error?.localizedDescription as Any)
            }else{
                imageV.image = image
            }

        })
        if rate.currency == selectedCurrency.currency{
            self.accessoryType = .checkmark
        }else{
            self.accessoryType = .none
        }
    }
}
