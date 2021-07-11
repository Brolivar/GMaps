//
//  MapModelController.swift
//  MOIA-Maps
//
//  Created by Jose Bolivar on 10/7/21.
//

import Foundation

protocol MarkedLocationControllerProtocol: AnyObject {
    func getSelectedLocation() -> MarkedLocationProtocol?
    func requestLocationData(completion: @escaping (Bool) -> Void)
    func setSelectedCoordinates(latitude: Double, longitude: Double)
    func clearLocationData()
}


class MarkedLocationModelController {

    // MARK: - Properties
    var selectedLongitude: Double?
    var selectedLatitude: Double?

    //This should be private but Swift doesn't allow private vars in protocols - Privacy is accomplished by injecting an abstraction
    // 'MarkedLocationControllerProtocol' rather of a type 'MarkedLocationModelController'
    var selectedLocation: MarkedLocationProtocol?
    private var networkManager: NetworkControllerProtocol = NetworkManager()
}

// MARK: - MarkedLocationControllerProtocol extension
extension MarkedLocationModelController: MarkedLocationControllerProtocol {
    func clearLocationData() {
        // We clear previous selected location
        self.selectedLocation = .none
        self.selectedLongitude = .none
        self.selectedLatitude = .none
    }


    func setSelectedCoordinates(latitude: Double, longitude: Double) {
        self.selectedLatitude = latitude
        self.selectedLongitude = longitude
    }

    func getSelectedLocation() -> MarkedLocationProtocol? {
        return selectedLocation
    }

    func requestLocationData(completion: @escaping (Bool) -> Void) {
        if let selectedLongitude = self.selectedLongitude, let selectedLatitude = self.selectedLatitude {
            self.networkManager.downloadLocationData(latitude: selectedLatitude, longitude: selectedLongitude) { result in
                switch result {
                case .success(let selectedAddress):
                    print("Location data request successfully")
                    self.selectedLocation = selectedAddress
                    completion(true)
                 case .failure(let error):
                    print("Location data request failed: ", error)
                    completion(false)
                }
            }
        } else {
            print("Error: No selected coordinates")
            completion(false)
        }

    }

}

