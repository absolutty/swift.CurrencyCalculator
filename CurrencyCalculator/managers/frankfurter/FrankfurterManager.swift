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
    
    func getTimeSeries(from fromCurrency: String, to toCurrency: String, completion: @escaping (Result<TimeSeriesResponse, AFError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        let start = Date().startOfMonth()
        let end = Date().endOfMonth()
        
        let urlString = FrankfurterManager.BASE_URL + "/" + formatter.string(from: start) + ".." + formatter.string(from: end) + "?base=\(fromCurrency)" + "&symbols=\(toCurrency)"
            
        AF.request(urlString, method: .get)
            .validate()
            .responseDecodable(of: TimeSeriesResponse.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
}
