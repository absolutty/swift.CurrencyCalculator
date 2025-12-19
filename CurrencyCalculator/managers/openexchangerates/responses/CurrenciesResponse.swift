import Foundation

class CurrenciesResponse: Decodable {
    let rates: [String: String]
}
