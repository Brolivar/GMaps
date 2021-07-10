//
//  MarkedLocation.swift
//  MOIA-Maps
//
//  Created by Jose Bolivar on 10/7/21.
//

import Foundation


protocol MarkedLocationProtocol {
    func getStreetName() -> String
    func getStreetNumber() -> Int?
    func getPostalCode() -> Int
    func getCountry() -> String
    func getLocality() -> String
}

// By abstracting the Marked Location into a protocol we ensure the whole object is not shared,
// only the protocol with the functions to read or write, which is way safer.
struct MarkedLocation: Codable {
    private var streetName: String       // Street name
    private var streetNumber: Int?
    private var postalCode: Int
    private var country: String
    private var locality: String

    init(streetName: String, streetNumber: Int?, postalCode: Int, country: String, locality: String) {
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.postalCode = postalCode
        self.country = country
        self.locality = locality
    }

    enum CodingKeys: String, CodingKey {
        case streetName = "route"
        case streetNumber = "street_number"
        case postalCode = "postal_code"
        case country = "country"
        case locality = "locality"
    }
}

//// MARK: - StoryProtocol Extension
extension MarkedLocation: MarkedLocationProtocol {

    func getStreetName() -> String {
        return streetName
    }

    func getStreetNumber() -> Int? {
        return streetNumber
    }

    func getPostalCode() -> Int {
        return postalCode
    }

    func getCountry() -> String {
        return country
    }

    func getLocality() -> String {
        return locality
    }
}

