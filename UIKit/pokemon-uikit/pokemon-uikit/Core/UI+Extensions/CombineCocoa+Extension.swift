//
//  CombineCocoa+Extension.swift
//  pokemon-uikit
//
//  Created by bokyung on 6/23/25.
//

import Combine
import CombineCocoa
import UIKit

public extension UIView {
    var touchPublisher: AnyPublisher<UITapGestureRecognizer, Never> {
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture.tapPublisher
    }
}
