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
        
        if rate.currency != nil{
            titleL.text = rate.currency?.localize()
        }else{
            titleL.text = rate.currencyCode
        }
        ImageManager.shared.getCountryImage(url: rate.imgURL, customSize: .zero, completion: { [self] image, error in
            if error != nil{
                print(error?.localizedDescription as Any)
                let imConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .small)
                let placeholder = UIImage(systemName: "photo.circle",withConfiguration: imConfig)
                imageV.image = placeholder
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
