
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
import AzureMapsRoute

final class AzureMapsRouteTests: XCTestCase {
    func test_getRouteDirections_shouldReturnRouteDirections() {
        let sut = makeSUT()
        let expectation = expectation(description: "getRouteDirections should return")

        sut.getRouteDirections(routePoints: anyRoutePoints()) { [self] result, _ in
            assertSuccessfulResult(result) { routeDirections in
                assertRoutesAreValid(routeDirections.routes)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getRouteDirections_withAdditionalParameters_shouldReturnRouteDirections() throws {
        throw XCTSkip("GeoJsonObject generated without `coordinates` property, so we cannot provide a proper geojson object, thus the request fails.")

        let sut = makeSUT()
        let expectation = expectation(description: "getRouteDirections with additional parameters should return")

        sut.getRouteDirections(routePoints: anyRoutePoints(), additionalParameters: anyRouteDirectionsParameters()) { [self] result, _ in
            assertSuccessfulResult(result) { routeDirections in
                assertRoutesAreValid(routeDirections.routes)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_requestRouteDirectionsBatchSync_shouldReturnBatchedRouteDirections() {
        let sut = makeSUT()
        let expectation = expectation(description: "requestRouteDirectionsBatchSync should return")

        sut.requestRouteDirectionsBatchSync(request: anyBatchRequest()) { [self] result, _ in
            assertSuccessfulResult(result) { routeDirectionsBatchResult in
                assertRouteBatchItemsContainRouteDirections(routeDirectionsBatchResult.batchItems)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_requestRouteDirectionsBatch_withGetRouteDirectionsBatch_shouldReturnBatchedRouteDirections() {
        let sut = makeSUT()
        let expectation = expectation(description: "requestRouteDirectionsBatch and getRouteDirectionsBatch should return")

        sut.requestRouteDirectionsBatch(request: anyBatchRequest()) { [self] result, response in
            guard let batchId = getBatchIdAndAssertResponseHasIt(response) else {
                expectation.fulfill()
                return
            }

            sut.getRouteDirectionsBatch(batchId: batchId) { result, _ in
                assertSuccessfulResult(result) { routeDirectionsBatchResult in
                    XCTAssertNotNil(routeDirectionsBatchResult, "RouteDirectionsBatchResult should not be nil")
                    assertRouteBatchItemsContainRouteDirections(routeDirectionsBatchResult?.batchItems)
                }

                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getRouteRange_shouldReturnRouteRange() {
        let sut = makeSUT()
        let expectation = expectation(description: "getRouteRange should return")

        sut.getRouteRange(query: anyRouteRangeQuery(), options: GetRouteRangeOptions(timeBudgetInSec: 6000)) { [self] result, _ in
            assertSuccessfulResult(result) { routeRangeResult in
                assertRouteRangeIsValid(routeRangeResult.reachableRange)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_requestRouteMatrixSync_shouldReturnRouteMatrix() {
        let sut = makeSUT()
        let expectation = expectation(description: "requestRouteMatrixSync should return")

        sut.requestRouteMatrixSync(query: anyRouteMatrixQuery()) { [self] result, _ in
            assertSuccessfulResult(result) { routeMatrixResult in
                assertRouteMatrixIsValid(routeMatrixResult.matrix)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_requestRouteMatrix_withGetRouteMatrix_shouldReturnRouteMatrix() {
        let sut = makeSUT()
        let expectation = expectation(description: "requestRouteMatrix and getRouteMatrix should return")

        sut.requestRouteMatrix(query: anyRouteMatrixQuery()) { [self] result, response in
            guard let matrixId = getMatrixIdAndAssertResponseHasIt(response) else {
                expectation.fulfill()
                return
            }

            sut.getRouteMatrix(matrixId: matrixId) { result, _ in
                assertSuccessfulResult(result) { routeMatrixResult in
                    XCTAssertNotNil(routeMatrixResult, "RouteMatrixResult should not be nil")
                    assertRouteMatrixIsValid(routeMatrixResult?.matrix)
                }

                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Helpers

    func makeSUT() -> RouteClient {
        RouteClient(credential: SharedTokenCredential("PUT_YOUR_SUBSCRIPTION_KEY_HERE"))
    }

    func assertSuccessfulResult<T>(_ result: Result<T, AzureError>, file: StaticString = #file, line: UInt = #line, successCompletion: (T) -> Void) {
        switch result {
        case .failure(let error):
            XCTFail(error.message, file: file, line: line)
        case .success(let result):
            successCompletion(result)
        }
    }

    func assertRoutesAreValid(_ routes: [RouteEntity]?, file: StaticString = #file, line: UInt = #line) {
        guard let routes = routes else {
            XCTFail("Routes should not be nil", file: file, line: line)
            return
        }

        XCTAssertFalse(routes.isEmpty, "Routes should not be empty", file: file, line: line)

        for route in routes {
            XCTAssertNotNil(route.summary?.lengthInMeters, "Route should contain info")
        }
    }

    func assertRouteBatchItemsContainRouteDirections(_ batchItems: [RouteDirectionsBatchItem]?, file: StaticString = #file, line: UInt = #line) {
        guard let batchItems = batchItems else {
            XCTFail("Batch items should not be nil", file: file, line: line)
            return
        }

        XCTAssertFalse(batchItems.isEmpty, "Batch items should not be empty", file: file, line: line)

        for item in batchItems {
            assertRoutesAreValid(item.response?.routes, file: file, line: line)
        }
    }

    func assertRouteRangeIsValid(_ routeRange: RouteRange?, file: StaticString = #file, line: UInt = #line) {
        guard let routeRange = routeRange else {
            XCTFail("RouteRange should not be nil", file: file, line: line)
            return
        }

        XCTAssertNotNil(routeRange.center, "RouteRange should have center")
        XCTAssertNotNil(routeRange.center?.latitude, "RouteRange should have center's latitude")
        XCTAssertNotNil(routeRange.center?.longitude, "RouteRange should have center's longitude")

        if let boundary = routeRange.boundary {
            XCTAssertFalse(boundary.isEmpty, "RouteRange's boundary should not be empty")

            for coordinate in boundary {
                XCTAssertNotNil(coordinate.latitude, "RouteRange's boundary items should have latitude")
                XCTAssertNotNil(coordinate.longitude, "RouteRange's boundary items should have longitude")
            }
        } else {
            XCTFail("RouteRange should have boundary")
        }
    }

    func assertRouteMatrixIsValid(_ routeMatrix: [[RouteMatrix]]?, file: StaticString = #file, line: UInt = #line) {
        guard let routeMatrix = routeMatrix else {
            XCTFail("RouteMatrix should not be nil", file: file, line: line)
            return
        }

        XCTAssertFalse(routeMatrix.isEmpty, "RouteMatrix should have rows", file: file, line: line)

        for row in routeMatrix {
            XCTAssertFalse(row.isEmpty, "RouteMatrix should have columns", file: file, line: line)

            for column in row {
                XCTAssertNotNil(column.response?.summary?.lengthInMeters, "RouteMatrix should have valid routes")
            }
        }
    }

    func getLocationHeaderAndAssertResponseHasIt(_ response: HTTPResponse?) -> String? {
        guard let response = response else {
            XCTFail("Response should not be nil")
            return nil
        }

        guard let location = response.headers[.location], !location.isEmpty else {
            XCTFail("Response should have location header")
            return nil
        }

        return location
    }

    func getBatchIdAndAssertResponseHasIt(_ response: HTTPResponse?) -> String? {
        guard let locationURLString = getLocationHeaderAndAssertResponseHasIt(response) else {
            return nil
        }

        // FIXME: The following below needs to be resolved
        // It's weird that we get the complete url string from the location header,
        // but we need to extract the id in such an ugly way,
        // so we can pass it to the appropriate method on the client,
        // which, in turn, creates the same url under the hood.
        let locationComponents = locationURLString.components(separatedBy: "/batch/")
        guard locationComponents.count > 1 else {
            XCTFail("Response's location header should be batch url")
            return nil
        }

        let batchId = locationComponents[1].prefix(while: { $0 != "?" })
        guard !batchId.isEmpty else {
            XCTFail("Response's location header should have batch id")
            return nil
        }

        return String(batchId)
    }

    func getMatrixIdAndAssertResponseHasIt(_ response: HTTPResponse?) -> String? {
        guard let locationURLString = getLocationHeaderAndAssertResponseHasIt(response) else {
            return nil
        }

        // FIXME: The following below needs to be resolved (see description above)
        let locationComponents = locationURLString.components(separatedBy: "/matrix/")
        guard locationComponents.count > 1 else {
            XCTFail("Response's location header should be matrix url")
            return nil
        }

        let matrixId = locationComponents[1].prefix(while: { $0 != "?" })
        guard !matrixId.isEmpty else {
            XCTFail("Response's location header should have matrix id")
            return nil
        }

        return String(matrixId)
    }

    func anyRoutePoints() -> String {
        "52.50931,13.42936:52.50274,13.43872"
    }

    func anyRouteRangeQuery() -> [Double] {
        [50.97452, 5.86605]
    }

    func anyRouteDirectionsParameters() -> RouteDirectionParameters {
        RouteDirectionParameters(
            supportingPoints: GeoJsonGeometryCollection(
                type: .geoJsonPoint,
                geometries: [GeoJsonObject(type: .geoJsonPoint)]
            )
        )
    }

    func anyBatchRequest() -> BatchRequest {
        BatchRequest(
            batchItems: [
                BatchRequestItem(query: "?query=47.639987,-122.128384:47.621252,-122.184408:47.596437,-122.332000&routeType=fastest&travelMode=car&maxAlternatives=5"),
                BatchRequestItem(query: "?query=47.620659,-122.348934:47.610101,-122.342015&travelMode=bicycle&routeType=eco&traffic=false"),
                BatchRequestItem(query: "?query=40.759856,-73.985108:40.771136,-73.973506&travelMode=pedestrian&routeType=shortest")
            ]
        )
    }

    func anyRouteMatrixQuery() -> RouteMatrixQuery {
        RouteMatrixQuery(
            origins: GeoJsonMultiPoint(
                type: .geoJsonMultiPoint,
                coordinates: [
                    [
                        4.85106,
                        52.36006
                    ],
                    [
                        4.85056,
                        52.36187
                    ]
                ]
            ),
            destinations: GeoJsonMultiPoint(
                type: .geoJsonMultiPoint,
                coordinates: [
                    [
                        4.85003,
                        52.36241
                    ],
                    [
                        13.42937,
                        52.50931
                    ]
                ]
            )
        )
    }
}
