//
//  ApiResponses.swift
//  MOIA-Maps
//
//  Created by Jose Bolivar on 10/7/21.
//

import Foundation

struct APIMapResponse: Codable {
    let status: String
    let results: [APISingleAddressResponse]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case results = "results"
    }
}

// Response containing all the components of a single address
struct APISingleAddressResponse: Codable {
    let addressComponents: [APIAddressComponent]
    // We could keep adding here rest of attributes like formatted_address and so on...
    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
    }
}

struct APIAddressComponent: Codable {
    let name: String
    let types: [String]
    enum CodingKeys: String, CodingKey {
        case name = "long_name"
        case types = "types"
    }
}
