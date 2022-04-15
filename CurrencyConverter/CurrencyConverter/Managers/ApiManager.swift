//
//  ApiManager.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 14/04/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager{
    
    static let shared = APIManager()
    
    static let apiUrl = "https://demo32.netteller.com.cy/netteller-apis-war/apis/systemTools/exchangeRatesInfo"
    
    //    class func..
    func headers() -> HTTPHeaders{
        var headers: HTTPHeaders = [
            .authorization(bearerToken: "eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiIxZGJmNWEzNC1mNGU3LTRhMGQtYjNkZS03NzU1OTU1YTM2N2MiLCJpc3MiOiJodHRwczovL2RlbW8zMi5uZXR0ZWxsZXIuY29tLmN5L25ldHRlbGxlci13YXIvTG9naW4ueGh0bWwiLCJzdWIiOiIiLCJhdWQiOiJlYmU2NmM5ZGI4Y2Y0NjIyODZmYTJlZjY5YjQ5MmU1OSIsImlhdCI6MTU1NDM4NDU5OSwiZXhwIjoxODY5NzQ0NTk5fQ.smdmZcySHKCN39Ddbind4hUUwHSM40Jetu7DIB-jlygyH8pEqqhUV60mKBViGpKz4rKRs-aZHTk9ZTP0YWrL7w"),
            .contentType("application/json"),
        ]
        
        headers.add(name:"x-client-id", value: "ebe66c9db8cf462286fa2ef69b492e59")
        headers.add(name: "x-fapi-financial-id", value: "CYDBCY2NXXXR")
        headers.add(name: "x-fapi-interaction-id", value: "da963011-7031-4f76-9fce-fd00f3197fdd")
        headers.add(name: "Language", value: "en")
        return headers
    }
    
   
    
    func fetchInfo(completion:@escaping(_ baseRate:ExchangeRate?, _ otherRates:[ExchangeRate], _ error:Error?)->Void){
        AF.request(APIManager.apiUrl, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers())
            .validate()
            .response { response in
                print(response)
                
//                let json = JSON(response.value as Any)
//                print(json)
                
                switch response.result {
                    
                case .success(let data):
                    
                    let newJSONDecoder = JSONDecoder()
                    
                    if let rates = try? newJSONDecoder.decode(Rates.self, from: data!){
                        let exRates = rates.data.exchangeRates
                        let baseRate = rates.data.baseExchangeRate
                        completion(baseRate, exRates, nil)
                    }else{
                        completion(nil,[],CError.noData)
                    }
                    
                case .failure(let error):
                    
                    if let underlyingError = error.underlyingError {
                        if let urlError = underlyingError as? URLError {
                            
                            var error = ""
                            switch urlError.code {
                            case .timedOut:
                                error = "Timed out error"
                            case .notConnectedToInternet:
                                error = "Not connected to Internet"
                            case .badURL:
                                error = "Bad Url"
                            case .cancelled:
                                error = "Request has been Cancelled"
                            default:
                                error = "Unmanaged error"
                            }
                            print("error connecting to api: \(error)")
                            
                            completion(nil,[], urlError)
                        }
                    }
                    
                    
                }
            }
    }
    
    //    MARK: STRUCT
    // MARK: - Rates
    
    
    struct Rates: Codable {
        let status, statusCode: String
        let data: DataClass
        let links: Links
        let meta: Meta
        let message: String
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let country: Country
        let baseExchangeRate: ExchangeRate
        let lastUpdate: String
        let exchangeRates: [ExchangeRate]
        public init(country:Country, baseExchangeRate:ExchangeRate, lastUpdate:String, exchangeRates:[ExchangeRate]){
            self.country = country
            self.baseExchangeRate = baseExchangeRate
            self.lastUpdate = lastUpdate
            self.exchangeRates = exchangeRates
        }
    }
    
    // MARK: - ExchangeRate
    struct ExchangeRate: Codable {
        let buyRate: Double
        let currency: String?
        let reverseRate: Bool
        let decimalPlaces: String
        let sellRate: Double
        let currencyCode: String
        let imgURL: String
        
        enum CodingKeys: String, CodingKey {
            case buyRate, currency, reverseRate, decimalPlaces, sellRate, currencyCode
            case imgURL = "imgUrl"
        }
    }
    
    // MARK: - Country
    struct Country: Codable {
        let imageURL: String
        let countryCode, name: String
    }
    
    // MARK: - Links
    struct Links: Codable {
        let linksSelf: String
        
        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
        }
    }
    
    // MARK: - Meta
    struct Meta: Codable {
        let totalPages: String
    }
}


