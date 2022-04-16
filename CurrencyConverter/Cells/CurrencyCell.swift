//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 15/04/2022.
//

import Foundation
import UIKit

protocol CurrencyChangeDelegate{
    func didSelectCurrencyChangeDelegate(countryRate:APIManager.ExchangeRate)
}

class CurrencyCell:UITableViewCell, UICollectionViewDataSource{
   
    @IBOutlet weak var collectionView: UICollectionView!

    static let cellIdentifier = "customCellIdentifier"
    
    static func nib()->UINib{
        return UINib(nibName: "CurrencyCell", bundle: nil)
    }
   
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        
        self.layer.borderColor = isEditable ? UIColor.systemBlue.cgColor : UIColor.systemGray.cgColor
        
        self.layer.borderWidth = 2
    }
   
    var exRate:APIManager.ExchangeRate!
    var delegate: CurrencyChangeDelegate?
    var isEditable:Bool!
    
    
//    MARK: Cell Setup
    func setupCell(rate:APIManager.ExchangeRate){
        exRate = rate
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.register(CollectionViewCellDetails.nib(), forCellWithReuseIdentifier: CollectionViewCellDetails.cellIdentifier)
        collectionView.register(CollectionCellTextField.nib(), forCellWithReuseIdentifier: CollectionCellTextField.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func updateData(rate:APIManager.ExchangeRate){
        let indexP = IndexPath(row: 1, section: 0)
        let countryCell = collectionView.cellForItem(at: indexP) as! CollectionViewCellDetails
        countryCell.countryLabel.text = rate.currency
        ImageManager.shared.getCountryImage(url: rate.imgURL, customSize: .zero, completion: { image, error in
            countryCell.countryImage.image = image
        })
        
    }
    
}
 

//MARK: CollectionView Delegates
extension CurrencyCell:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row % 2 == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellTextField.cellIdentifier, for: indexPath) as! CollectionCellTextField
            cell.textField.keyboardType = .decimalPad
            cell.textField.placeholder = "0.00"
            cell.textField.textAlignment = .center
            cell.textField.isUserInteractionEnabled = false// isEditable
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellDetails.cellIdentifier, for: indexPath) as! CollectionViewCellDetails
            cell.isEditable = isEditable
            cell.setupCell(exchangeRate: exRate)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
            if !CustomKeyboard.shared.isPresented{
                CustomKeyboard.shared.presentKeyboard()
            }
            
        }else{
            delegate?.didSelectCurrencyChangeDelegate(countryRate: exRate)
        }
    }
}

//MARK: UITextFieldDelegate
//extension CurrencyCell: UITextFieldDelegate{
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        print(1)
//        return false
//    }
//}

//MARK: CollectionViewDelegateFlowLayout
extension CurrencyCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row % 2 == 0{
            return CGSize(width: (self.bounds.width / 5) * 3, height: self.bounds.height)
        }else{
            return CGSize(width: (self.bounds.width / 5) * 2, height: self.bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}

extension UIApplication {
    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            } else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        return topViewController
    }
}
