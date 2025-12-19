//
//  FrankfurterManager.swift
//  CurrencyCalculator
//
//  Created by Adam Hajro on 19/12/2025.
//

import Foundation
import Alamofire

class FrankfurterManager {
    //MARK: constants
    static let BASE_URL = "https://api.frankfurter.dev/v1"
    
    //MARK: singleton instance of class
    static let shared = FrankfurterManager()
    
    //MARK: getConversion: konverzia na zaklade hodnoty
    //uskutocnena fromCurrency --> toCurrency
    func getConversion(
        from fromCurrency: String,
        to toCurrency: String,
        value: Double,
        completion: @escaping (Result<ConversionResponse, AFError>) -> Void
    ) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let urlString = FrankfurterManager.BASE_URL + "/latest?" + "base=\(fromCurrency)" + "&symbols=\(toCurrency)"
        
        AF.request(urlString, method: .get)
            .validate()
            .responseDecodable(of: ConversionResponse.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
}
