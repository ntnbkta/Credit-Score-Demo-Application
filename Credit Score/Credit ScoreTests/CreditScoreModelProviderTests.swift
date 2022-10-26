//
//  CreditScoreModelProviderTests.swift
//  Credit ScoreTests
//
//  Created by Nithin Bhaktha on 16/10/22.
//

import XCTest
@testable import Credit_Score

final class MockDataProvider: JSONProviderService {
    
    enum JSONDataType: String {
        case valid
        case invalid
        case empty
    }
    
    var dataType: JSONDataType = .valid
        
    func requestData(for api: Credit_Score.APIRequest, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        fetchMockJSONData(completion)
    }

    private func fetchMockJSONData(_ completion: (Result<Data, NetworkError>) -> ()) {
        switch dataType {
        case .valid:
            let user = MockUser.user()
            let creditCardUsers = CreditCardDetail(users: [user])
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            let userData = try? encoder.encode(creditCardUsers)
            completion(.success(userData!))
        case .invalid:
            completion(.failure(.noJSONData))
        case .empty:
            completion(.failure(.noJSONData))
        }
        return
    }
}

final class CreditScoreModelProviderTests: XCTestCase {

    var sut: UserManager?
    
    override func setUp() {
        super.setUp()
        sut = UserManager.shared
    }

    func testCSModelProvider_validJSON() {
        let mockDataProvider = MockDataProvider()
        mockDataProvider.dataType = .valid
        sut?.jsonDataProvider = mockDataProvider
        sut?.fetchCreditCardUser ({ result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            default:
                XCTFail("Result should always be a non-nil User")
            }
        })
    }
    
    func testCSModelProvider_invalidJSON() {
        let mockDataProvider = MockDataProvider()
        mockDataProvider.dataType = .invalid
        sut?.jsonDataProvider = mockDataProvider

        sut?.fetchCreditCardUser({ result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssert(error == .noJSONData)
            default:
                XCTFail("Result should always be an error object")
            }
        })
    }

    func testCSModelProvider_emptyJSON() {
        let mockDataProvider = MockDataProvider()
        mockDataProvider.dataType = .empty
        sut?.jsonDataProvider = mockDataProvider

        sut?.fetchCreditCardUser({ result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssert(error == .noJSONData)
            default:
                XCTFail("Result should always be an error object")
            }
        })
    }
    
    func testJSONDataFromBundle() {
        let mockDataProvider = MockDataProvider()
        mockDataProvider.dataType = .valid
        sut?.jsonDataProvider = mockDataProvider
        
        sut?.fetchCreditCardUserFromBundle({ result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            default:
                XCTFail("Result should always be a non-nil User")
            }
        })
    }
}

extension UserProvider {
    
    func fetchCreditCardUserFromBundle(_ completion: @escaping (Result<User, JSONError>) -> ()) {
        
        if let path = Bundle.main.url(forResource: "valid", withExtension: "json") {
            let jsonData = try? Data(contentsOf: path)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                let users = try decoder.decode(CreditCardDetail.self, from: jsonData!)
                completion(.success(users.users.first!))
            } catch {
                completion(.failure(.badJSONData))
            }
        }
    }
}

extension Bundle {
    static let UnitTestBundle = Bundle(for: CreditScoreModelProviderTests.self)
}
