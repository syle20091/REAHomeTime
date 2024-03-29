//
//  Copyright (c) 2015 REA. All rights reserved.
//

import UIKit
import XCTest
@testable import HomeTime

class DateFormatterTest: XCTestCase {
  func testShouldConvertTimeIntervalToDateString() {
    let converter = DotNetDateConverter()
    let result = converter.formattedDateFromString("/Date(1426821588000+1100)/")
    XCTAssertEqual(result, "02:19 PM")
  }
}
