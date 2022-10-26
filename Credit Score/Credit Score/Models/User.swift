//
//  User.swift
//  Credit Score
//
//  Created by Nithin Bhaktha on 14/10/22.
//

import Foundation

/// Model to represent Credit card detail
struct CreditCardDetail: Codable {
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case users = "credit_card_users"
    }
}

/// Model to represent Credit card User
struct User: Codable {
    let id: Int
    let name: String
    let scoreContent: UserCreditScore
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "user_name"
        case scoreContent = "credit_score"
    }
}
    
/// Model to represent Credit card User's Score
struct UserCreditScore: Codable {
    let score: Int
    let onDate: Date
    let marketView: [MarketCreditScoreRange]
    
    enum CodingKeys: String, CodingKey {
        case score = "score"
        case onDate = "on_date"
        case marketView = "score_range"
    }
}

/// Model to represent Credit card's Market Range
struct MarketCreditScoreRange: Codable {
    
    let min: Int
    let max: Int
    let percentage: Int
    
    enum CodingKeys: String, CodingKey {
        case min = "min"
        case max = "max"
        case percentage = "share_percentage"
    }
}
