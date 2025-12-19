import Foundation

class LatestResponse: Decodable {
    let base: String
    let rates: [String: Double]
}
