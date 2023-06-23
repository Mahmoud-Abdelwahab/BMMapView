//
//  UIView+Extension.swift
//  AppleMapFramework
//
//  Created by Mahmoud Abdulwahab on 22/06/2023.
//

import UIKit

public extension UIView {
    func loadNibFromFile() {
        let bundle = Bundle(for: BMMapView.self)
        guard let nibName = BMMapView.self.description().components(separatedBy: ".").last
        else { return }
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? BMMapView
        else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
