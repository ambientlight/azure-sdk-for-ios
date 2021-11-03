
// --------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// --------------------------------------------------------------------------

import XCTest
import Foundation
@testable import AzureMapsTimezone

final class AzureMapsTimezoneTests: XCTestCase {
    func testGetLocation(){
        
        let client = try! TimezoneClient.init(credential: SharedTokenCredential(""), withOptions: TimezoneClientOptions())
        let expectation = expectation(description: "should return")
        client.getTimezoneByCoordinates(
            coordinates: [47.0, -122],
            withOptions: GetTimezoneByCoordinatesOptions(options: .all)
        ) { result, response in
            switch result {
            case .failure(let error):
                XCTFail(error.message)
            case .success(let result):
                XCTAssertEqual(result.timeZones?.first?.aliases?.first, "US/Pacific")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
