//
//  StoryboardUtil.swift
//  CreditScoreUI
//
//  Created by Nithin Bhaktha on 13/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    /// Main storyboard
    static var creditScore: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.creditScoreUIBundle())
    }
    
    /*
     @abstract: Instantiates and returns the view controller with the specified identifier. This util assumes the identifier of the view controller is the name of the class
     @param: identifier, uniquely identifies equals to Class name
     @result: The view controller corresponding to the specified identifier string. If no view controller is associated with the string, this method throws an exception.
     */
    func instantiateViewController<T>(withIdentifier identifier: T.Type) -> T where T: UIViewController {
        let className = String(describing: identifier)
        guard let vc =  self.instantiateViewController(withIdentifier: className) as? T else {
            fatalError("Cannot find controller with identifier \(className)")
        }
        return vc
    }
}

extension Bundle {
    static func creditScoreUIBundle() -> Bundle {
        return Bundle(for: CreditScoreViewController.self)
    }
}
