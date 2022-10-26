//
//  NetworkClientTests.swift
//  Credit ScoreTests
//
//  Created by Nithin Bhaktha on 16/10/22.
//

import XCTest
@testable import Credit_Score
import OHHTTPStubs

final class NetworkClientTests: XCTestCase {

    func testValidRequestResponse () {

        let exp = expectation(description: "Fetch Status")
        let testScheme = "test"

        stub(condition: isScheme(testScheme)) { (req) -> OHHTTPStubsResponse in

            return OHHTTPStubsResponse(data: Bundle.UnitTest.getData(file: .valid)!, statusCode: 200, headers: nil)
        }

        let api = APIRequest(urlString: "\(testScheme)://www.test.com")
        NetworkClient.Shared.requestData(for: api) { (result) in
            XCTAssertNotNil(try? result.get())
            exp.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testInvalidRequest () {
        let exp = expectation(description: "Fetch Status")
        let testScheme = "test1"

        stub(condition: isScheme(testScheme)) { (req) -> OHHTTPStubsResponse in

            return OHHTTPStubsResponse(data: Bundle.UnitTest.getData(file: .valid)!, statusCode: 200, headers: nil)
        }

        let api = APIRequest(urlString: "\(testScheme)://www.test 1.com")
        NetworkClient.Shared.requestData(for: api) { (result) in

            defer {
                exp.fulfill()
            }
            switch result {
                case .success(_):
                    XCTFail("unexpected success")
                case .failure(let error):
                guard  case NetworkError.invalidRequest = error else {
                    XCTFail("unexpected error")
                    return
                }
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testErrorResponse () {
        let exp = expectation(description: "Fetch Status")
        let testScheme = "test2"

        stub(condition: isScheme(testScheme)) { (req) -> OHHTTPStubsResponse in

            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            return OHHTTPStubsResponse(error: error)

        }

        let api = APIRequest(urlString: "\(testScheme)://www.test.com")
        NetworkClient.Shared.requestData(for: api) { (result) in

            defer {
                exp.fulfill()
            }
            switch result {
                case .success(_):
                    XCTFail("unexpected success")
                case .failure(let error):
                    guard  case NetworkError.unknown = error else {
                        XCTFail("unexpected error")
                        return
                }
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testInvalidStatusCodes () {
        let exp = expectation(description: "Fetch Status")
        let testScheme = "test2"

        stub(condition: isScheme(testScheme)) { (req) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)

        }

        let api = APIRequest(urlString: "\(testScheme)://www.test.com")
        NetworkClient.Shared.requestData(for: api) { (result) in

            defer {
                exp.fulfill()
            }
            switch result {
                case .success(_):
                    XCTFail("unexpected success")
                case .failure(let error):
                    guard  case NetworkError.badStatus = error else {
                        XCTFail("unexpected error")
                        return
                }
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }

}
