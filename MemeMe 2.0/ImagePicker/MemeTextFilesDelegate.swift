//
//  MemeTextFilesDelegate.swift
//  ImagePicker
//
//  Created by Binyamin Alfassi on 8/16/20.
//  Copyright © 2020 RBG Designs. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFilesDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.uppercased()
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = textField.text?.uppercased()
        textField.textColor = UIColor.white
        
        return true
    }
}
