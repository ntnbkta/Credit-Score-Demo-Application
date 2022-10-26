//
//  CreditScoreUICoordinatorTests.swift
//  Credit ScoreTests
//
//  Created by Nithin Bhaktha on 26/10/22.
//

import XCTest
@testable import Credit_Score

final class CreditScoreUICoordinatorTests: XCTestCase {

    var sut: CreditScoreUICoordinator?
    
    override func setUp() {
        super.setUp()
        sut = CreditScoreUICoordinator()
    }

    func test() {
        let user = MockUser.user()
        XCTAssertNotNil(sut?.viewControllerFor(user))
    }
}
