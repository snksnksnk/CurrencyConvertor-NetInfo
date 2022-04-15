//
//  OtherCurrencies.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 15/04/2022.
//

import Foundation
import UIKit

protocol OtherRatesDelegate{
    func didSelectSwitchCurrency(currency:APIManager.ExchangeRate)
}

class OtherCurrenciesController:UIViewController{
    var exRates:[APIManager.ExchangeRate]!
    var selectedCurrency:APIManager.ExchangeRate!
    var tableView:UITableView!
    var delegate:OtherRatesDelegate?
    
    init(rates:[APIManager.ExchangeRate], selected:APIManager.ExchangeRate) {
        super.init(nibName: nil, bundle: nil)
        exRates = rates
        selectedCurrency = selected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let barbutton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissController))
        self.navigationItem.rightBarButtonItem = barbutton
        self.title = "Exchange to"
        self.navigationController!.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidLoad() {
        tableView = UITableView(frame: self.view.bounds, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.register(CCell.nib(), forCellReuseIdentifier: "ce")
//        tableView.register(CCell.self, forCellReuseIdentifier: "ce")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    @objc func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension OtherCurrenciesController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "ce", for: indexPath) as! CCell
        cell2.selectedCurrency = selectedCurrency
        cell2.setupCell(rate: exRates[indexPath.row])

        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true){ [self] in
            delegate?.didSelectSwitchCurrency(currency: exRates[indexPath.row])
        }
        
    }
}
