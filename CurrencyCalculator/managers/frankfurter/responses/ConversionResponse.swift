//
//  ConversionResponse.swift
//  CurrencyCalculator
//
//  Created by Adam Hajro on 19/12/2025.
//

import Foundation

struct ConversionResponse: Decodable {
    let base: String
    let rates: [String: Double]
}
