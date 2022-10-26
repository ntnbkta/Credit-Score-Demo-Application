//
//  CreditScoreUIProvider.swift
//  Credit Score
//
//  Created by Nithin Bhaktha on 25/10/22.
//

import Foundation
import CreditScoreUISDK

protocol CreditScoreUIProvider {
    
    func viewControllerFor(_ user: User) -> UIViewController
}

class CreditScoreUICoordinator : CreditScoreUIProvider {
    
    func viewControllerFor(_ user: User) -> UIViewController {
        let range = CreditScoreRange(worst: user.scoreContent.marketView[0].asCreditScoreRange(),
                                     bad: user.scoreContent.marketView[1].asCreditScoreRange(),
                                     average: user.scoreContent.marketView[2].asCreditScoreRange(),
                                     good: user.scoreContent.marketView[3].asCreditScoreRange(),
                                     excellent: user.scoreContent.marketView[4].asCreditScoreRange())
        let model = CreditScoreModel(score: user.scoreContent.score,
                                     scoreDate: user.scoreContent.onDate,
                                     scoreRange: range)
        return CreditScoreUIFactory.makeCreditScoreUI(model)
    }
}

extension MarketCreditScoreRange {
    
    func asCreditScoreRange() -> CreditScoreMarketRange {
        return CreditScoreMarketRange(minScore: min, maxScore: max, percentageShare: percentage)
    }
}
