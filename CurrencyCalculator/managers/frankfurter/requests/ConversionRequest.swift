//
//  ConversionRequest.swift
//  CurrencyCalculator
//
//  Created by Adam Hajro on 22/12/2025.
//

struct LatestConversionRequest: Encodable {
    let base: String
    let symbols: String
}
