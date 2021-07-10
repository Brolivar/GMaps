//
//  NetworkManager.swift
//  MOIA-Maps
//
//  Created by Jose Bolivar on 10/7/21.
//

import Foundation


protocol NetworkControllerProtocol: AnyObject {
    func downloadLocationData(latitude: Double, longidute: Double, completion: @escaping (Result<MarkedLocation?, NetworkError>) -> Void)
}

// Error tracking for the API request:
// On a real scenario, more errors would be used/added, for better accuracy tracking
enum NetworkError: Error {
    case requestError
    case timeoutError
    case decodingError
}

class NetworkManager {}

extension NetworkManager: NetworkControllerProtocol {

    func downloadLocationData(latitude: Double, longidute: Double, completion: @escaping (Result<MarkedLocation?, NetworkError>) -> Void) {

        var markedLocation: MarkedLocation?          // Retrieved Location Data
        if let markedLocationURL = URL(string: AppURL.base + AppURL.Api.geocode + (String(latitude)) + "," + (String(longidute)) + AppURL.Api.apiKey) {
            URLSession.shared.dataTask(with: markedLocationURL, completionHandler: { (data, response, error) in
                do {
                    guard let responseData = data else {
                        completion(.failure(.requestError))
                        return
                    }

                    let response: APIMapResponse = try JSONDecoder().decode(APIMapResponse.self, from: responseData)

                    if let addressData = response.results {
                        // We use the first element on the array, since the results contains the same address on multiple format, so we can just use the first one for simplicity
                        if let addressDataFormatted = addressData.first {
                            // We track and store the ones we require to display using the 'types' attribute
                            var postalCode: Int?
                            var streetNumber: Int?
                            var streetName: String?
                            var locality: String?
                            var country: String?

                            for component in addressDataFormatted.addressComponents {
                                // Note: another workaround for this would have been defining an encodable enum on the 'ApiResponses' file,
                                // with the attributes we require
                                switch component.types.first {
                                case MarkedLocation.CodingKeys.streetName.stringValue:
                                    streetName = component.name
                                case MarkedLocation.CodingKeys.streetNumber.stringValue:
                                    streetNumber = Int(component.name)
                                case MarkedLocation.CodingKeys.locality.stringValue:
                                    locality = component.name
                                case MarkedLocation.CodingKeys.country.stringValue:
                                    country = component.name
                                case MarkedLocation.CodingKeys.postalCode.stringValue:
                                    postalCode = Int(component.name)
                                case .none:
                                    break
                                case .some(_):
                                    break
                                }
                            }
                            // Safely unwrap to check that we have all our data
                            if let streetName = streetName, let postalCode = postalCode, let country = country, let locality = locality {
                                markedLocation = MarkedLocation(streetName: streetName, streetNumber: streetNumber, postalCode: postalCode, country: country, locality: locality)
                                if response.status == "OK" {
                                    completion(.success(markedLocation))
                                } else {
                                    completion(.failure(.requestError))
                                }
                            } else {
                                print("Error: Incomplete data.")
                                completion(.failure(.requestError))
                            }
                        } else {
                            completion(.failure(.requestError))
                        }
                    }
                } catch {
                    print(error)
                    completion(.failure(.decodingError))
                }
            }).resume()
        }
    }
}
