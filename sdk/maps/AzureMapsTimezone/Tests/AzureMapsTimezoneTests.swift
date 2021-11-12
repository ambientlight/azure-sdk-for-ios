
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
import AzureCore
import AzureMapsTimezone

final class AzureMapsTimezoneTests: XCTestCase {
    func test_getTimezoneById_shouldReturnTimeZones() {
        let sut = makeSUT()
        let expectation = expectation(description: "getTimezoneById should return")

        sut.getTimezoneById(
            timezoneId: "Asia/Bahrain",
            options: GetTimezoneByIDOptions(options: .all)
        ) { [self] result, _ in
            assertSuccessfulResult(result) { timezoneResult in
                XCTAssertEqual(timezoneResult.timeZones?.first?.names?.daylight, "Arabian Daylight Time")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getTimezoneByCoordinates_shouldReturnTimeZones() {
        let sut = makeSUT()
        let expectation = expectation(description: "getTimezoneByCoordinates should return")

        sut.getTimezoneByCoordinates(
            coordinates: [47.0, -122],
            options: GetTimezoneByCoordinatesOptions(options: .all)
        ) { [self] result, _ in
            assertSuccessfulResult(result) { timezoneResult in
                XCTAssertEqual(timezoneResult.timeZones?.first?.aliases?.first, "US/Pacific")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getWindowsTimezoneIds_shouldReturnTimeZoneWindows() {
        let sut = makeSUT()
        let expectation = expectation(description: "getWindowsTimezoneIds should return")

        sut.getWindowsTimezoneIds { [self] result, _ in
            assertSuccessfulResult(result) { timezoneWindows in
                XCTAssertNotNil(timezoneWindows.first?.windowsId)
                XCTAssertNotNil(timezoneWindows.first?.territory)
                XCTAssertNotNil(timezoneWindows.first?.ianaIds)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getIanaTimezoneIds_shouldReturnIanaIds() {
        let sut = makeSUT()
        let expectation = expectation(description: "getIanaTimezoneIds should return")

        sut.getIanaTimezoneIds { [self] result, _ in
            assertSuccessfulResult(result) { ianaIds in
                XCTAssertNotNil(ianaIds.first?.id)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getIanaVersion_shouldReturnIanaVersion() {
        let sut = makeSUT()
        let expectation = expectation(description: "getIanaVersion should return")

        sut.getIanaVersion { [self] result, _ in
            assertSuccessfulResult(result) { timezoneIanaVersionResult in
                XCTAssertNotNil(timezoneIanaVersionResult.version)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_convertWindowsTimezoneToIana_shouldReturnIanaIds() {
        let sut = makeSUT()
        let expectation = expectation(description: "convertWindowsTimezoneToIana should return")

        sut.convertWindowsTimezoneToIana(windowsTimezoneId: "Eastern Standard Time") { [self] result, _ in
            assertSuccessfulResult(result) { ianaIds in
                XCTAssertNotNil(ianaIds.first?.id)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Helpers

    func makeSUT() -> TimezoneClient {
        // FIXME: replace with env variables
        TimezoneClient(credential: SharedTokenCredential("PUT_YOUR_SUBSCRIPTION_KEY_HERE"))
    }

    func assertSuccessfulResult<T>(_ result: Result<T, AzureError>, file: StaticString = #file, line: UInt = #line, successCompletion: (T) -> Void) {
        switch result {
        case .failure(let error):
            XCTFail(error.message, file: file, line: line)
        case .success(let result):
            successCompletion(result)
        }
    }
}
