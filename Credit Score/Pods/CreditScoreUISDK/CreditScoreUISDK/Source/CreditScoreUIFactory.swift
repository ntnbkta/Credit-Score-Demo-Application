//
//  CreditScoreUIFactory.swift
//  CreditScoreUI
//
//  Created by Nithin Bhaktha on 14/10/22.
//

import Foundation
import UIKit

public class CreditScoreUIFactory {
 
    /*! @abstract: Entry point to CreditScoreUISDK. Instantiates a CreditScoreViewController representing CreditScoreModel
        @param: scoreModel, an instance of CreditScoreModel which has data regarding Users Credit card score and the market ranges.
        @return returns UIViewController, which has embedded views to display the UI for User's Credit Card Score.
        @discussion The returned UIViewController has views which can be used to present Credit Card Score of a User. The UI consists of 2 views. First one is a circular animated progress view with a large label depicting User's Credit Card Score and the second one is a view which has bars depicting market ranges and a pointer as to where the User's Credit score is with respect to the market ranges.
     */
    public static func makeCreditScoreUI(_ scoreModel: CreditScoreModel) -> UIViewController {
        let vc = UIStoryboard.creditScore.instantiateViewController(withIdentifier: CreditScoreViewController.self)
        vc.model = scoreModel
        return vc
    }
}
