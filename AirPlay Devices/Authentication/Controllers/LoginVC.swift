//
//  LoginVC.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import UIKit

class LoginVC: UIViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    // MARK: - VARIABLES AND CONSTANTS
    var viewModel: LoginVM = LoginVM()
    let activityIndicator = ActivityIndicator()

    // MARK: - LOADING VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configView()
    }

    // MARK: - BUTTON ACTIONS
    @IBAction func loginAction(_ sender: UIButton) {
        self.view.endEditing(true)
        makeRequest()
    }

    // MARK: - FUNCTIONS
    func configView(){
        emailField.becomeFirstResponder()
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

        viewModel.isLoggedIn.bind { [weak self] isLoading in
            guard let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    let nextVC = AppController.shared.home
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }

    }

    func makeRequest() {
        do {
            _ = try ValidationService.validate(email: emailField.text)
            _ = try ValidationService.validate(password: passwordField.text)
            viewModel.signIn(email: emailField.text ?? "", password: passwordField.text ?? "")
        } catch {
            print(error.localizedDescription)
            AppToastView.shared.showToast(message: error.localizedDescription,toastType: .warning)
        }
    }
}
