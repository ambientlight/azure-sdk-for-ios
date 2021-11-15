
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
import AzureMapsElevation

final class AzureMapsElevationTests: XCTestCase {
    func test_getDataForBoundingBox_shouldReturnElevations() {
        let sut = makeSUT()
        let expectation = expectation(description: "getDataForBoundingBox should return")

        sut.getDataForBoundingBox(bounds: anyBounds(), rows: 3, columns: 3) { [self] result, _ in
            assertResultHasElevations(result)
                
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getDataForPoints_shouldReturnElevations() {
        let sut = makeSUT()
        let expectation = expectation(description: "getDataForPoints should return")

        sut.getDataForPoints(points: anyPoints()) { [self] result, _ in
            assertResultHasElevations(result)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getDataForPolyline_shouldReturnElevations() {
        let sut = makeSUT()
        let expectation = expectation(description: "getDataForPolyline should return")

        sut.getDataForPolyline(lines: anyPolyline()) { [self] result, _ in
            assertResultHasElevations(result)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_postDataForPoints_shouldReturnElevations() {
        let sut = makeSUT()
        let expectation = expectation(description: "postDataForPoints should return")

        sut.postDataForPoints(points: anyDataPoints()) { [self] result, _ in
            assertResultHasElevations(result)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_postDataForPolyline_shouldReturnElevations() {
        let sut = makeSUT()
        let expectation = expectation(description: "postDataForPolyline should return")

        sut.postDataForPolyline(lines: anyDataPolyline()) { [self] result, _ in
            assertResultHasElevations(result)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Helpers

    func makeSUT() -> ElevationClient {
        // FIXME: replace with env variables
        ElevationClient(credential: SharedTokenCredential("PUT_YOUR_SUBSCRIPTION_KEY_HERE"))
    }

    func assertElevationsAreValid(_ elevations: [ElevationEntity]?, file: StaticString = #file, line: UInt = #line) {
        guard let elevations = elevations else {
            XCTFail("Elevations should not be nil", file: file, line: line)
            return
        }

        XCTAssertFalse(elevations.isEmpty, "Elevations should not be empty", file: file, line: line)

        for elevation in elevations {
            XCTAssertNotNil(elevation.coordinate, "Elevation should contain coordinate", file: file, line: line)
            XCTAssertNotNil(elevation.elevationInMeter, "Elevation should contain elevationInMeter", file: file, line: line)
        }
    }

    func assertResultHasElevations(_ result: Result<ElevationResult, AzureError>, file: StaticString = #file, line: UInt = #line) {
        switch result {
        case .failure(let error):
            XCTFail(error.message, file: file, line: line)
        case .success(let result):
            assertElevationsAreValid(result.elevations, file: file, line: line)
        }
    }

    func anyBounds() -> [Float] {
        [-121.66853362143818, 46.84646479863713, -121.65853362143818, 46.85646479863713]
    }

    func anyPoints() -> [String] {
        ["-121.66853362143818,46.84646479863713", "-121.65853362143818,46.85646479863713"]
    }

    func anyPolyline() -> [String] {
        ["-121.66853362143818,46.84646479863713", "-121.65853362143818,46.85646479863713"]
    }

    func anyDataPoints() -> [LatLongPairAbbreviated] {
        [
            LatLongPairAbbreviated(lat: 46.84646479863713, lon: -121.66853362143818),
            LatLongPairAbbreviated(lat: 46.85646479863713, lon: -121.65853362143818)
        ]
    }

    func anyDataPolyline() -> [LatLongPairAbbreviated] {
        [
            LatLongPairAbbreviated(lat: 46.84646479863713, lon: -121.66853362143818),
            LatLongPairAbbreviated(lat: 46.85646479863713, lon: -121.65853362143818)
        ]
    }
}
