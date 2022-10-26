//
//  Extensions.swift
//  CreditScoreUISDK
//
//  Created by Nithin Bhaktha on 19/10/22.
//

import UIKit

extension UIView {
    
    /*! @abstract Creates snapshot of the view
        @result returns an instance of UIImage
     */
    func makeSnapshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
    }
}
