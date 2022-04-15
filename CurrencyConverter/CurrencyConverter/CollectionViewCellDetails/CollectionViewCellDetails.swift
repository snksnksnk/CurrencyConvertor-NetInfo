//
//  CollectionViewCellDetails.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 15/04/2022.
//

import Foundation
import UIKit

class CollectionViewCellDetails:UICollectionViewCell{
    static let cellIdentifier = "collectionViewCellDetails"
    
    static func nib()->UINib{
        return UINib(nibName: "CollectionViewCellDetails", bundle: nil)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
//    MARK: Setup Cell
    
    var isEditable:Bool!
    override func draw(_ rect: CGRect) {
        if isEditable{
            self.layer.addBorder(side: .left, thickness: 2, color: UIColor.systemBlue.cgColor)
        }else{
            self.layer.addBorder(side: .left, thickness: 2, color: UIColor.systemGray.cgColor)
        }
    }
    
    func setupCell(exchangeRate:APIManager.ExchangeRate){
        
        let imConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .small)
        let arImage = UIImage(systemName: "chevron.down",withConfiguration: imConfig)
        arrowImage.image = isEditable ? arImage : UIImage()
        
        if exchangeRate.imgURL != ""{
            ImageManager.shared.getCountryImage(url: exchangeRate.imgURL, customSize: .zero) { [self] image, error in
                countryImage.image = image
                countryImage.contentMode = .scaleAspectFit
                countryLabel.text = exchangeRate.currencyCode
                
            }
            
        }
        
    }
    
}



