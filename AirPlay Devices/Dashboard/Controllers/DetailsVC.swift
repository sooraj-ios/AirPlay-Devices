//
//  DetailsVC.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import UIKit

class DetailsVC: UIViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var hostnameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var postalLabel: UILabel!
    @IBOutlet weak var timezoneLabel: UILabel!
    @IBOutlet weak var readmeLabel: UILabel!

    // MARK: - VARIABLES AND CONSTANTS
    var viewModel: DetailsVM = DetailsVM()
    let activityIndicator = ActivityIndicator()

    // MARK: - LOADING VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }

    // MARK: - BUTTON ACTIONS
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - FUNCTIONS
    func configView(){
        viewModel.fetchIPAddress()
    }

    func bindViewModel() {
        viewModel.isLoadingData.bind { [weak self] isLoading in
            guard let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.show()
                } else {
                    self?.activityIndicator.hide()
                }
            }
        }

        viewModel.showError.bind { message in
            guard let message = message else {
                return
            }
            AppToastView.shared.showToast(message: message, toastType: .error)
        }

        viewModel.geoData.bind { [weak self] geoData in
            guard let geoData = geoData else {
                return
            }
            DispatchQueue.main.async {
                self?.ipLabel.text = geoData.ip
                self?.hostnameLabel.text = geoData.hostname
                self?.cityLabel.text = geoData.city
                self?.regionLabel.text = geoData.region
                self?.countryLabel.text = geoData.country
                self?.locLabel.text = geoData.loc
                self?.orgLabel.text = geoData.org
                self?.postalLabel.text = geoData.postal
                self?.timezoneLabel.text = geoData.timezone
                self?.readmeLabel.text = geoData.readme
            }
        }
    }
}
