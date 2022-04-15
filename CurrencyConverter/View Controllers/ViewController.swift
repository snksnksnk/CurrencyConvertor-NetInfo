//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 14/04/2022.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource {
    
    var tableView: UITableView!
    var exRates:[APIManager.ExchangeRate]!
    var bRate:APIManager.ExchangeRate!
    var selectedCurrency:APIManager.ExchangeRate!
    var spinner:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.register(CurrencyCell.nib(), forCellReuseIdentifier: CurrencyCell.cellIdentifier)
        spinner = UIActivityIndicatorView(frame: self.view.bounds)
        spinner.startAnimating()
        tableView.backgroundView = spinner
        
        self.view.addSubview(tableView)

        
        fetch()
    }
    
    func fetch(){
//        APIManager.shared.fetchLocal { [self] baseRate, otherRates, error in
            
        APIManager.shared.fetchInfo { [self] baseRate, otherRates, error in
            if error != nil{
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                
                tableView.setEmptyView(title: "Something went wrong", message: "Please try again later or\ncontact the admin")
                
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }else{
                exRates = otherRates
                bRate = baseRate!
                selectedCurrency = otherRates[0]
                
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
            }
        }
    }
    
}




//MARK: Custom Delegate
extension ViewController:CurrencyChangeDelegate{
    func didSelectCurrencyChangeDelegate(countryRate: APIManager.ExchangeRate) {
        let filter = exRates.filter{$0.currencyCode != "KES"}
        let otherCurrenciesCon = OtherCurrenciesController(rates: filter, selected: selectedCurrency)
        otherCurrenciesCon.delegate = self
        let nC = UINavigationController(rootViewController: otherCurrenciesCon)
        nC.modalPresentationStyle = .formSheet

        self.present(nC, animated: true)
    }
}


extension ViewController:OtherRatesDelegate{
    func didSelectSwitchCurrency(currency: APIManager.ExchangeRate) {
        selectedCurrency = currency
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CurrencyCell
        cell.updateData(rate: currency)
    }
}

extension ViewController:CustomKeyboardDelegate{
    func didPressDone() {
        CustomKeyboard.shared.dismissKeyboard()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CurrencyCell
        let colCel = cell.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! CollectionCellTextField
//        colCel.textField.resignFirstResponder()
        
        let cell2 = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CurrencyCell
        let colCel2 = cell2.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! CollectionCellTextField
        
        if colCel.textField.text != ""{
        colCel2.textField.text = String(format:"%.2f",calculate(amount: colCel.textField.text!, toCurrency: selectedCurrency))
        }
    }
    
    func didType(number: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CurrencyCell
        let colCel = cell.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! CollectionCellTextField
        colCel.textField.text?.append(number)
    }
    
    func didPressDelete() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CurrencyCell
        let colCel = cell.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! CollectionCellTextField
        colCel.textField.text?.removeLast()
    }
}


//    MARK: TableView Delegates
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Available Rates"
        case 1:
            return "Base Rate"
        default:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section{
        case 0:
            return 55
        case 1:
            return 55
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
       
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.cellIdentifier, for: indexPath) as! CurrencyCell
            cell.isEditable = true
            cell.setupCell(rate: exRates[indexPath.row])
            cell.delegate = self
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.cellIdentifier, for: indexPath) as! CurrencyCell
//            let filter = exRates.filter{$0.currencyCode == "KES"}
            cell.isEditable = false
            cell.setupCell(rate: bRate)
            
            return cell
        }else{
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            var cellConfig = buttonCell.defaultContentConfiguration()
            cellConfig.text = "Convert"
            cellConfig.textProperties.alignment = .center
            
            var backConfig = buttonCell.backgroundConfiguration
            backConfig?.backgroundColor = .systemBlue.withAlphaComponent(0.5)
            
            buttonCell.contentConfiguration = cellConfig
            buttonCell.backgroundConfiguration = backConfig
            
            return buttonCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
           break
        case 1:
            break
        case 2:
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CurrencyCell
            let colCel = cell.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! CollectionCellTextField
            colCel.textField.resignFirstResponder()
            
            let cell2 = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CurrencyCell
            let colCel2 = cell2.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! CollectionCellTextField
            
            if colCel.textField.text != ""{
                colCel2.textField.text = String(format:"%.2f",calculate(amount: colCel.textField.text!, toCurrency: selectedCurrency))
            }
           
        default:
            break
        }
    }
    
    func calculate(amount:String, toCurrency:APIManager.ExchangeRate)->Double{
        let am = Double(amount)
        return (am! * toCurrency.buyRate * bRate.sellRate)
    }
}




