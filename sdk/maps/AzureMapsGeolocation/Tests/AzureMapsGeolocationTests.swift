
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
import AzureMapsGeolocation

final class AzureMapsGeolocationTests: XCTestCase {
    func test_getLocation_shouldReturnCorrectCountryRegionISOCode() {
        let sut = makeSUT()
        let expectation = expectation(description: "get location should return")

        sut.getLocation(ipAddress: "140.113.0.0") { result, _ in
            switch result {
            case .failure(let error):
                XCTFail(error.message)
            case .success(let result):
                XCTAssertEqual(result.countryRegion?.isoCode, "TW")
            }
    
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Helpers

    func makeSUT() -> GeolocationClient {
        // FIXME: replace with env variables
        GeolocationClient(credential: SharedTokenCredential("PUT_YOUR_SUBSCRIPTION_KEY_HERE"))
    }
}
