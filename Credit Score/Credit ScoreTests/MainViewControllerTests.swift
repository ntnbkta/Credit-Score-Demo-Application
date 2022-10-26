//
//  MainViewControllerTests.swift
//  Credit ScoreTests
//
//  Created by Nithin Bhaktha on 16/10/22.
//

import XCTest
@testable import Credit_Score

final class MockUserProvider: UserProvider {

    func fetchCreditCardUser(_ completion: @escaping (Result<User, JSONError>) -> ()) {
        let user = MockUser.user()
        completion(.success(user))
    }
}

final class MockUICoordinator: CreditScoreUIProvider {
    func viewControllerFor(_ user: User) -> UIViewController {
        return UIViewController()
    }
}

final class MainViewControllerTests: XCTestCase {

    var sut: MainViewController? = nil
    
    override func setUp() {
        super.setUp()
        sut = MainViewController()
        embedInNavigationController(vc: sut!)
        sut?.loadViewIfNeeded()
    }
    
    func embedInNavigationController( vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        nav.loadViewIfNeeded()
    }

    func testShowCreditScoreUI() {
        sut?.dataProvider = MockUserProvider()
        sut?.scoreUICoordinator = MockUICoordinator()

        XCTAssert(self.sut?.navigationController?.viewControllers.count == 1)

        let exp = expectation(description: "Present Credit Score UI")
        sut?.showCreditScore(UIButton())

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssert(self.sut?.navigationController?.viewControllers.count == 2)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
}
