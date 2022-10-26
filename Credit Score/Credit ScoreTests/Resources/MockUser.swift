//
//  MockUser.swift
//  Credit ScoreTests
//
//  Created by Nithin Bhaktha on 26/10/22.
//

import Foundation
@testable import Credit_Score

struct MockUser {
    
    static func user() -> User {
        let ranges = [MarketCreditScoreRange(min: 300, max: 699, percentage: 19),
                      MarketCreditScoreRange(min: 700, max: 774, percentage: 19),
                      MarketCreditScoreRange(min: 775, max: 799, percentage: 19),
                      MarketCreditScoreRange(min: 800, max: 824, percentage: 19),
                      MarketCreditScoreRange(min: 825, max: 900, percentage: 19)]
        let user = User(id: 110,
                        name: "Applessed",
                        scoreContent:UserCreditScore(score: 820,
                                                     onDate: Date(),
                                                     marketView: ranges))
        return user
    }
}
