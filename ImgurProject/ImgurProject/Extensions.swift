//
//  Extensions.swift
//  ImgurProject
//
//  Created by Fedii Ihor on 13.07.2022.
//

import UIKit

extension UIViewController {
    public func someWrongAlert(_ title: String ,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
