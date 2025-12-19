import Foundation

struct LatestRequest: Encodable {
    let appId: String
    let base: String
    
    enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case base
    }
}
