//
//  APITest.swift
//  EarthQuakeTests
//
//  Created by Matthew Jagiela on 4/3/21.
//

import XCTest
@testable import EarthQuake
class APITest: XCTestCase {
    let api = APIHandler()
    func testAPIWorking() {
        let apiExpectation = expectation(description: "APIResponse")
        api.fetchEarthQuakeData { (response, data) in
            switch response {
            case .success:
                XCTAssertNotNil(data)
            case .APIError(let code):
                XCTFail("API FAILURE = \(code)")
            default:
                XCTFail("Error on our end")
            }
            apiExpectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

}
