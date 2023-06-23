//
//  UIView+Extension.swift
//  AppleMapFramework
//
//  Created by Mahmoud Abdulwahab on 22/06/2023.
//

import UIKit

public extension UIView {
    func loadViewFromNib() {
        let nib = UINib(nibName: String(describing: self), bundle: .module)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
