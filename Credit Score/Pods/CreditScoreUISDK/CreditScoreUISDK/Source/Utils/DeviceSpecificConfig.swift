//
//  DeviceSpecificConfig.swift
//  CreditScoreUISDK
//
//  Created by Nithin Bhaktha on 21/10/22.
//

import UIKit

/// A Generic Data type, to gather requirements for specific devices.
struct DeviceSpecificConfig <T> {
    var ipad: T
    var iphone: T
    var unspecified: T
    
    subscript(idiom: UIUserInterfaceIdiom) -> T {
        switch idiom {
        case .pad  :
            return self.ipad
        case .phone:
            return self.iphone
        default:
            return self.unspecified
        }
    }
}
