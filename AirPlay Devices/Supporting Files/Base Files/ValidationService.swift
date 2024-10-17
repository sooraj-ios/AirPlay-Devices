//
//  ValidationService.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import UIKit

enum ValidationError: Error {

    //MARK: - Email -
    case emptyMail
    case wrongMail

    //MARK: - Password -
    case emptyPassword
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        //MARK: - Email -
        case .emptyMail:
            return "Please enter email field."
        case .wrongMail:
            return "Please enter correct email address."
        case .emptyPassword:
            return "Please enter password field."
        }
    }
}

struct ValidationService {

    //MARK: - Email -
    static func validate(email: String?) throws -> String {
        guard let email = email, !email.isEmpty else {
            throw ValidationError.emptyMail
        }
        guard email.isValidEmail() else{
            throw ValidationError.wrongMail
        }
        return email
    }

    //MARK: - Password -
    static func validate(password: String?) throws -> String {
        guard let password = password, !password.isEmpty else {
            throw ValidationError.emptyPassword
        }
        return password
    }

}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}
