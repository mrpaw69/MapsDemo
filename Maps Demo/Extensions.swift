//
//  Extensions.swift
//  Maps Demo
//
//  Created by paw on 05.02.2021.
//

import UIKit

extension UIViewController{
    func showError(errorMessage: String?){
        let ac = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}
