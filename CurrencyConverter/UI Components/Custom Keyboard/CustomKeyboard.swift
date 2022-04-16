//
//  CustomKeyboard.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 15/04/2022.
//

import Foundation
import UIKit

protocol CustomKeyboardDelegate{
    func didPressDone()
    func didType(number:String)
    func didPressDelete()
}

class CustomKeyboard:UIView{
    var cView:UIView!
    var collectionView:UICollectionView!
    var delegate:CustomKeyboardDelegate?
    
    static let shared = CustomKeyboard()
    var buttons:[String] = ["1","2","3","4","5","6","7","8","9","delete","0","Done"]
    var isPresented:Bool = false
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.itemSize = CGSize(width: self.bounds.width/3.4, height: self.bounds.height/4.8)
        
        collectionView = UICollectionView(frame: self.bounds,collectionViewLayout: layout)
        collectionView.register(CustomKeyboardButton.nib(), forCellWithReuseIdentifier: CustomKeyboardButton.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        
        self.addSubview(collectionView)
        
    }
    
    public func presentKeyboard(){
        
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height + 10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.7)
        let topcontroller = UIApplication.shared.topViewController() as! ViewController
        topcontroller.view.addSubview(self)
        self.delegate = topcontroller
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.frame.origin.y = (UIScreen.main.bounds.height) - UIScreen.main.bounds.height/2.7
        } completion: { [self] success in
            isPresented = true
        }
    }
    
    public func dismissKeyboard(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.frame.origin.y = UIScreen.main.bounds.height + 10
        } completion: { [self] success in
                isPresented = false
        }
        
    }
    
//    public func toggle(){
//        if isPresented{
//           
//
//        }else{
//           
//        }
//        isPresented.toggle()
//    }
}

extension CustomKeyboard:UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
}

extension CustomKeyboard:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomKeyboardButton.cellIdentifier, for: indexPath) as! CustomKeyboardButton
        
        
        cell.cLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.cLabel.textAlignment = .center
        
        if buttons[indexPath.row] == "Done"{
            cell.cLabel.text = buttons[indexPath.row]
            cell.cLabel.textColor = .systemBlue.withAlphaComponent(0.9)
            cell.cLabel.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        }else if buttons[indexPath.row] == "delete"{
            
            let configIm = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .small)
            let imageAttachment = NSTextAttachment()
            let fullString = NSMutableAttributedString(string: "")
           
                imageAttachment.image = UIImage(systemName: "delete.left", withConfiguration: configIm)?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed)
                fullString.append(NSMutableAttributedString(attachment: imageAttachment))
            
                cell.cLabel.attributedText = fullString
            cell.cLabel.backgroundColor = .systemRed.withAlphaComponent(0.15)
        }else{
            cell.cLabel.text = buttons[indexPath.row]
            cell.cLabel.backgroundColor = .systemBackground
        }
//        cell.cLabel.layer.shadowColor = UIColor.black.cgColor
//        cell.cLabel.layer.shadowOffset = .zero
//        cell.cLabel.layer.shadowRadius = 2
//        cell.cLabel.layer.shadowOpacity = 1
//        cell.cLabel.layer.masksToBounds = false
        cell.cLabel.layer.cornerRadius = 8
        cell.cLabel.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if buttons[indexPath.row] == "Done"{
            delegate?.didPressDone()
        }else if buttons[indexPath.row] == "delete"{
            delegate?.didPressDelete()
        }else{
            delegate?.didType(number: buttons[indexPath.row])
        }
    }
    
}

extension CustomKeyboard:UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15)
    }
    
}
