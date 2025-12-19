import Foundation

//app_id, start, end, symbols, base

struct TimeSeriesRequest: Encodable {
    let appId: String
    let base: String
    let start: String
    let end: String
    let symbols: String
    
    enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case base, start, end, symbols
    }
}
