//
//  Field.swift
//  officeV8
//
//  Created by dingjinming on 2018/8/9.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import Foundation
import UIKit

public extension UITextField {
    public func borderAndPlaceholder(place: String, text: String) {
        self.placeholder = place
        self.text = text
        self.borderStyle = .roundedRect
    }
}
