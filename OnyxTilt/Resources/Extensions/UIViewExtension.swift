//
//  UIViewExtension.swift
//  OnyxTilt
//
//  Created by DevMountain on 4/12/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentSimpleAlertWith(title: String, body: String?){
        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
