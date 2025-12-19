struct TimeSeriesResponse: Codable {
    let disclaimer: String
    let license: String
    let startDate, endDate, base: String
    let rates: [String: [String: Double]]

    enum CodingKeys: String, CodingKey {
        case disclaimer, license
        case startDate = "start_date"
        case endDate = "end_date"
        case base, rates
    }
}
