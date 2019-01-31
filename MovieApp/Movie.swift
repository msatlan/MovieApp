//
//  Movie.swift
//  MovieApp
//
//  Created by Marko Satlan on 30/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import Foundation



/*
 struct ExchangeRate: Codable {
 var currencyCode: String
 var unitValue: Int
 var buyingRate: Float
 var medianRate: Float
 var sellingRate: Float
 
 private enum CodingKeys: String, CodingKey {
 case currencyCode = "currency_code"
 case unitValue = "unit_value"
 case buyingRate = "buying_rate"
 case medianRate = "median_rate"
 case sellingRate = "selling_rate"
 }
 
 init(from decoder: Decoder) throws {
 let container = try decoder.container(keyedBy: CodingKeys.self)
 
 self.currencyCode = try container.decode(String.self, forKey: .currencyCode)
 self.unitValue = try container.decode(Int.self, forKey: .unitValue)
 self.buyingRate = Float(try container.decode(String.self, forKey: .buyingRate))!
 self.medianRate = Float(try container.decode(String.self, forKey: .medianRate))!
 self.sellingRate = Float(try container.decode(String.self, forKey: .sellingRate))!
 }
 }
 */
