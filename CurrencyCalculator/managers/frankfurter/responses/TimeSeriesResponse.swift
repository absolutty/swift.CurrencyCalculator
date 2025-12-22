struct TimeSeriesResponse: Codable {
    let base: String
    let startDate: String
    let endDate: String
    let rates: [String: [String: Double]]

    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case base
        case rates
    }
}
