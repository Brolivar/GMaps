//
//  MapModelController.swift
//  MOIA-Maps
//
//  Created by Jose Bolivar on 10/7/21.
//

import Foundation

protocol MarkedLocationControllerProtocol: AnyObject {
    func getSelectedLocation() -> MarkedLocationProtocol?
    func requestLocationData(latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void)
}


class MarkedLocationModelController {

    // MARK: - Properties

    //This should be private but Swift doesn't allow private vars in protocols - Privacy is accomplished by injecting an abstraction
    // 'MarkedLocationControllerProtocol' rather of a type 'MarkedLocationModelController'
    var selectedLocation: MarkedLocationProtocol?
    private var networkManager: NetworkControllerProtocol = NetworkManager()
}

// MARK: - StoriesControllerProtocol extension
extension MarkedLocationModelController: MarkedLocationControllerProtocol {

    func getSelectedLocation() -> MarkedLocationProtocol? {
        return selectedLocation
    }

    func requestLocationData(completion: @escaping (Bool) -> Void) {

    }

    func requestLocationData(latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {

        print("Requesting data...")
        self.networkManager.downloadLocationData(latitude: latitude, longidute: longitude) { result in
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
    }

}

