
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
import AzureMapsTraffic

final class AzureMapsTrafficTests: XCTestCase {
    func test_getTrafficFlowSegment_shouldReturnFlowSegmentData() {
        let sut = makeSUT()
        let expectation = expectation(description: "getTrafficFlowSegment should return")

        sut.getTrafficFlowSegment(style: .absolute, zoom: anyZoom(), coordinates: anyCoordinates()) { [self] result, _ in
            assertSuccessfulResult(result) { trafficFlowSegmentData in
                XCTAssertNotNil(trafficFlowSegmentData.flowSegmentData?.currentSpeed)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getTrafficFlowTile_shouldReturnImage() {
        let sut = makeSUT()
        let expectation = expectation(description: "getTrafficFlowTile should return")

        sut.getTrafficFlowTile(style: .absolute, zoom: anyZoom(), tileIndex: anyTileIndex()) { [self] result, response in
            assertSuccessfulResult(result)
            assertResponseHasImageRepresentableData(response)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getTrafficIncidentDetail_shouldReturnIncidentDetail() {
        let sut = makeSUT()
        let expectation = expectation(description: "getTrafficIncidentDetail should return")

        sut.getTrafficIncidentDetail(
            style: .s3,
            zoom: anyZoom(),
            boundingBox: anyBoundingBox(),
            boundingZoom: anyBoundingZoom(),
            trafficModelId: anyTrafficModelId()
        ) { [self] result, _ in
            assertSuccessfulResult(result) { trafficIncidentDetail in
                XCTAssertNotNil(trafficIncidentDetail.tm?.pointsOfInterest?.first?.lengthInMeters)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getTrafficIncidentTile_shouldReturnImage() {
        let sut = makeSUT()
        let expectation = expectation(description: "getTrafficIncidentTile should return")

        sut.getTrafficIncidentTile(style: .night, zoom: anyZoom(), tileIndex: anyTileIndex()) { [self] result, response in
            assertSuccessfulResult(result)
            assertResponseHasImageRepresentableData(response)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getTrafficIncidentViewport_shouldReturnIncidentViewport() {
        let sut = makeSUT()
        let expectation = expectation(description: "getTrafficIncidentViewport should return")

        sut.getTrafficIncidentViewport(
            boundingBox: anyBoundingBox(),
            boundingZoom: anyBoundingZoom(),
            overviewBox: anyBoundingBox(),
            overviewZoom: anyBoundingZoom()
        ) { [self] result, _ in
            assertSuccessfulResult(result) { trafficIncidentViewport in
                XCTAssertNotNil(trafficIncidentViewport.viewpResp?.maps)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Helpers

    func makeSUT() -> TrafficClient {
        // FIXME: replace with env variables
        TrafficClient(credential: SharedTokenCredential("PUT_YOUR_SUBSCRIPTION_KEY_HERE"))
    }

    func assertSuccessfulResult<T>(_ result: Result<T, AzureError>, file: StaticString = #file, line: UInt = #line, successCompletion: ((T) -> Void)? = nil) {
        switch result {
        case .failure(let error):
            XCTFail(error.message, file: file, line: line)
        case .success(let result):
            successCompletion?(result)
        }
    }

    func assertResponseHasImageRepresentableData(_ response: HTTPResponse?, file: StaticString = #file, line: UInt = #line) {
        guard let response = response else {
            XCTFail("Response should not be nil", file: file, line: line)
            return
        }

        guard let data = response.data else {
            XCTFail("Response should have data", file: file, line: line)
            return
        }

        XCTAssertNotNil(NSImage(data: data), "Response data should be image representable", file: file, line: line)
    }

    func anyZoom() -> Int32 {
        6
    }

    func anyCoordinates() -> [Double] {
        [52.41072, 4.84239]
    }

    func anyBoundingBox() -> [Double] {
        [6841263.950712, 511972.674418, 6886056.049288, 582676.925582]
    }

    func anyBoundingZoom() -> Int32 {
        11
    }

    func anyTrafficModelId() -> String {
        "1335294634919"
    }

    func anyTileIndex() -> TileIndex {
        TileIndex(x: 10, y: 22)
    }
}
