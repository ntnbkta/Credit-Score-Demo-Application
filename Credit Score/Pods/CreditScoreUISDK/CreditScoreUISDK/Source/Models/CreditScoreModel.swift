//
//  CreditScoreModel.swift
//  CreditScore
//
//  Created by Nithin Bhaktha on 13/10/22.
//

import Foundation

/// A Model, representing a User's Credit Score.
///  This has meta data consolidating user's credit score, the date as of the score was fetched and also a model representing market credit score ranges.
public struct CreditScoreModel {
    
    public var score: Int
    public var scoreDate: Date
    public var scoreRange: CreditScoreRange

    public init(score: Int, scoreDate: Date, scoreRange: CreditScoreRange) {
        self.score = score
        self.scoreDate = scoreDate
        self.scoreRange = scoreRange
    }
}

/// Model to represent Market Credit Score Ranges
///  These ranges are a custom data type representing min, max and the credit score share percentage making up the respective market range.
public struct CreditScoreRange {
    
    public var worst: CreditScoreMarketRange
    public var bad: CreditScoreMarketRange
    public var average: CreditScoreMarketRange
    public var good: CreditScoreMarketRange
    public var excellent: CreditScoreMarketRange
    
    public init(worst: CreditScoreMarketRange, bad: CreditScoreMarketRange, average: CreditScoreMarketRange, good: CreditScoreMarketRange, excellent: CreditScoreMarketRange) {
        self.worst = worst
        self.bad = bad
        self.average = average
        self.good = good
        self.excellent = excellent
    }
}

/// A custom data type representing min, max and the credit score share percentage making up the respective market range.
public struct CreditScoreMarketRange {
    
    public var minScore: Int
    public var maxScore: Int
    public var percentageShare: Int
    
    public init(minScore: Int, maxScore: Int, percentageShare: Int) {
        self.minScore = minScore
        self.maxScore = maxScore
        self.percentageShare = percentageShare
    }
}
