//
//  Alert.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 6/1/19.
//

import Foundation
import UIKit

class Alert {
    func showAlert(titleText: String, messageText: String) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
