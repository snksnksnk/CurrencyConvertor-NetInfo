//
//  ImageManager.swift
//  CurrencyConverter
//
//  Created by Demetris Georgiou on 15/04/2022.
//

import Foundation
import AlamofireImage
import Alamofire
import UIKit

@objc protocol ImageManagerDelegate{
    @objc optional func gotProgress(progress:CGFloat)
    func gotImage(image:UIImage?, error:Error?, indexPath:IndexPath)
}

class ImageManager{
    
    static var shared = ImageManager()
    var delegate:ImageManagerDelegate?
    
    private let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
    
//    func getCountryImage(url:String, customSize:CGSize, indexPath:IndexPath){
        
    
    func getCountryImage(url:String, customSize:CGSize, completion:@escaping(_ image:UIImage, _ error:Error?)->Void){
        
        
        if getFromCache(url: url) == UIImage(){
            
            AF.request(url).responseImage { [self] response in
                if case .success(let image) = response.result {
                    let urlRequest = URLRequest(url: URL(string: url)!)
                    imageCache.add(image, for: urlRequest, withIdentifier: "countryImage")
                    
                        completion(image, nil)
//                    delegate?.gotImage(image: image, error: nil, indexPath: indexPath)
                }
                
                if case .failure(let error) = response.result{
//                    delegate?.gotImage(image: nil, error: error, indexPath: indexPath)
                    completion(UIImage(), error)
                }
            }
            
        }else{
            if customSize == .zero{
//                delegate?.gotImage(image: getFromCache(url: url), error: nil, indexPath: indexPath)
                completion(getFromCache(url: url), nil)
            }else{
//                delegate?.gotImage(image: getFromCache(url: url), error: nil, indexPath: indexPath)

                completion(getFromCache(url: url), nil)
            }
        }
    }
    
    private func getFromCache(url:String)->UIImage{
        if let request = URL(string: url){
            let urlRequest = URLRequest(url: request)
            if let cachedImage = imageCache.image(for: urlRequest, withIdentifier: "countryImage"){
                return cachedImage
            }else{
                return UIImage()
            }
        }else{
            return UIImage()
        }
    }
}
