//
//  CustomError.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 15/04/2022.
//

import Foundation

enum CError: Error {
    case noData
}


extension CError:CustomStringConvertible{
    
    public var description:String{
        switch self {
        case .noData:
            return "No data in file?"
            
        }
    }
}

extension CError:LocalizedError{
    public var errorDescription: String?{
        switch self {
        case .noData:
            return NSLocalizedString("No data found", comment: "No data in file")
        }
    }
}
