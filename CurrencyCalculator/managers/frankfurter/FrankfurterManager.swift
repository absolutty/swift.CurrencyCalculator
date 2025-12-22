//
//  FrankfurterManager.swift
//  CurrencyCalculator
//
//  Created by Adam Hajro on 19/12/2025.
//

import Foundation
import Alamofire

class FrankfurterManager {
    
    private static let BASE_URL = "https://api.frankfurter.dev/v1"
    static let shared = FrankfurterManager()
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func getConversion(
        from fromCurrency: String,
        to toCurrency: String,
        value: Double,
        completion: @escaping (Result<ConversionResponse, AFError>) -> Void
    ) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let endpoint = FrankfurterManager.BASE_URL + "/latest"
        let request = LatestConversionRequest(base: fromCurrency, symbols: toCurrency)
        
        AF.request(endpoint, method: .get, parameters: request, encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .responseDecodable(of: ConversionResponse.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func getTimeSeries(
        from fromCurrency: String,
        to toCurrency: String,
        completion: @escaping (Result<TimeSeriesResponse, AFError>) -> Void
    ) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let start = Date().startOfMonth()
        let end = Date().endOfMonth()
        
        let dateRangePath = "\(dateFormatter.string(from: start))..\(dateFormatter.string(from: end))"
        let endpoint = "\(FrankfurterManager.BASE_URL)/\(dateRangePath)"
        
        let request = TimeSeriesRequest(base: fromCurrency, symbols: toCurrency)
        
        AF.request(endpoint, method: .get, parameters: request, encoder: URLEncodedFormParameterEncoder.default)
        .validate()
        .responseDecodable(of: TimeSeriesResponse.self, decoder: decoder) { response in
            completion(response.result)
        }
    }
}
