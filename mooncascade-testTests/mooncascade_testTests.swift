//
//  mooncascade_testTests.swift
//  mooncascade-testTests
//
//  Created by Dmitry Kanivets on 18.04.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import mooncascade_test

class mooncascade_testTests: XCTestCase {
    
    func testEmployeeToStorage_shouldMapJSONtoRLMEmployee() {
        if let path = Bundle.main.path(forResource: "employeesJSON", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let employeeSwiftyJSON = JSON(jsonResult)
                let employee = employeeSwiftyJSON["employees"].array?.first?.employeeToStorage()
                XCTAssertNotNil(employee)
            } catch {
                XCTFail()
            }
        }
    }
    
}
