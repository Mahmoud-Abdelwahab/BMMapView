//
//  UIView+Extension.swift
//  AppleMapFramework
//
//  Created by Mahmoud Abdulwahab on 22/06/2023.
//

import UIKit

public extension UIView {
    @discardableResult
    func loadViewFromNib<T: UIView>(bundle: Bundle = .main) -> T {
        let nibName = String(describing: type(of: self))
        
        guard let view = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? T else {
            fatalError("Failed to instantiate nib \(nibName)")
        }
        
        self.addSubview(view)
        view.frame = self.bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        return view
    }
}
