import Foundation
import Alamofire

class OpenExchangeRatesManager {
    //MARK: constants
    static let API_KEY = "461790475cd34270a67a8007a506eaac"
    static let BASE_URL = "https://openexchangerates.org/api"
    
    //MARK: singleton instance of class
    static let shared = OpenExchangeRatesManager()
    
    //MARK: getLatest: zoznam skratiek mien + ich hodnota
    func getLatest(base currency: String, completion: @escaping (Result<LatestResponse, AFError>) -> Void) {
        let request = LatestRequest(
            appId: OpenExchangeRatesManager.API_KEY,
            base: currency
        )
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
            
        AF.request(OpenExchangeRatesManager.BASE_URL + "/latest.json", method: .get, parameters: request)
            .validate()
            .responseDecodable(of: LatestResponse.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    //MARK: getLatest: zoznam skratiek mien + ich cely nazov
    func getCurrencies(completion: @escaping (Result<[String: String], AFError>) -> Void){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
            
        AF.request(OpenExchangeRatesManager.BASE_URL + "/currencies.json", method: .get)
            .validate()
            .responseDecodable(of: [String: String].self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
}
