//
//  UIViex+Extensions.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 6/3/22.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
