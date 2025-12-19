import Foundation

struct CurrenciesRequest: Encodable {
    let appId: String
    
    enum CodingKeys: String, CodingKey {
        case appId = "app_id"
    }
}
