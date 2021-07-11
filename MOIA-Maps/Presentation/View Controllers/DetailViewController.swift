//
//  DetailViewController.swift
//  MOIA-Maps
//
//  Created by Jose Bolivar on 11/7/21.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    static let detailSegueId = "showDetail"
    //Ideally this should be injected by a third party entity (i.e navigator, segue manager, etc...)
    var markedLocationManager: MarkedLocationModelController! = MarkedLocationModelController()
    @IBOutlet private var detailView: UIView!
    @IBOutlet private var headlineLabel: UILabel!
    @IBOutlet private var subheadLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.requestLocationData()
    }

    @IBAction private func dismissButtonTapped(_ sender: Any) {
        self.markedLocationManager.clearLocationData()
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Methods

    private func initUI() {
        headlineLabel.text = ""
        subheadLabel.text = ""
        self.view.backgroundColor = .clear
        self.detailView.layer.cornerRadius = 15
        self.detailView.backgroundColor = UIColor(named: "BackgroundColor")
        self.headlineLabel.textColor = UIColor(named: "PrimaryTextColor")
        self.headlineLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        self.subheadLabel.textColor = UIColor(named: "SecondaryTextColor")
        self.subheadLabel.font =  UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
    }

    private func requestLocationData() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false

        self.markedLocationManager.requestLocationData() { status in

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                if status {
                    if let selectedLocation = self.markedLocationManager.getSelectedLocation() {
                        var headlineText = selectedLocation.getStreetName()
                        // if there's street number we add it
                        if let streetNumber = selectedLocation.getStreetNumber() {
                            headlineText += " \(String(streetNumber))"
                        }
                        self.headlineLabel.text = headlineText
                        // subhead label
                        self.subheadLabel.text = "\(String(selectedLocation.getPostalCode())) \(selectedLocation.getLocality()), \(selectedLocation.getCountry())"
                    } else {
                        print("Error: selected location data is nil")
                    }
                } else {
                    print("Error retrieving selected location")
                    self.headlineLabel.text = ""
                    self.subheadLabel.text = ""
                }
            }

        }
    }
}
