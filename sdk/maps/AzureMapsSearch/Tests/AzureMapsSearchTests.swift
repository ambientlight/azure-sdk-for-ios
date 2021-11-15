
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
import AzureMapsSearch

final class AzureMapsSearchTests: XCTestCase {
    func test_fuzzySearch_shouldReturnSearchResults() {
        let sut = makeSUT()
        let expectation = expectation(description: "fuzzySearch should return")

        sut.fuzzySearch(query: "Seattle") { [self] result, _ in
            assertSuccessfulResult(result) { searchAddressResult in
                XCTAssertEqual(searchAddressResult.results?.first?.address?.countryCode, "US")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.countrySubdivision, "WA")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_fuzzySearchBatch_shouldReturnBatchedSearchResults() {
        let sut = makeSUT()
        let operation = sut.fuzzySearchBatch(request: anyFuzzySearchBatchRequest())
        let expectation = expectation(description: "fuzzySearchBatch should return")
        
        operation.pollUntilDone { [self] result, _ in
            assertSuccessfulResult(result) { batchResult in
                XCTAssertEqual(batchResult?.batchSummary?.successfulRequests, 3)
                assertSearchAddressBatchItemsAreValid(batchResult?.batchItems)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_searchAddress_shouldReturnSearchResults() {
        let sut = makeSUT()
        let expectation = expectation(description: "searchAddress should return")

        sut.searchAddress(query: "15127 NE 24th Street, Redmond, WA 98052") { [self] result, _ in
            assertSuccessfulResult(result) { searchAddressResult in
                XCTAssertEqual(searchAddressResult.results?.first?.address?.countryCode, "US")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.postalCode, "98052")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.countrySubdivision, "WA")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.municipality, "Redmond")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.streetName, "Northeast 24th Street")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.streetNumber, "15127")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_searchAddressBatch_shouldReturnBatchedSearchResults() {
        let sut = makeSUT()
        let operation = sut.searchAddressBatch(request: anySearchAddressBatchRequest())
        let expectation = expectation(description: "searchAddressBatch should return")

        operation.pollUntilDone { [self] result, _ in
            assertSuccessfulResult(result) { batchResult in
                XCTAssertEqual(batchResult?.batchSummary?.successfulRequests, 3)
                assertSearchAddressBatchItemsAreValid(batchResult?.batchItems)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_reverseSearchAddress_shouldReturnReverseSearchResults() {
        let sut = makeSUT()
        let expectation = expectation(description: "reverseSearchAddress should return")

        sut.reverseSearchAddress(query: [37.337, -121.89]) { [self] result, _ in
            assertSuccessfulResult(result) { reverseSearchAddressResult in
                XCTAssertEqual(reverseSearchAddressResult.addresses?.first?.address?.countryCode, "US")
                XCTAssertEqual(reverseSearchAddressResult.addresses?.first?.address?.postalCode, "95113")
                XCTAssertEqual(reverseSearchAddressResult.addresses?.first?.address?.countrySubdivision, "CA")
                XCTAssertEqual(reverseSearchAddressResult.addresses?.first?.address?.municipality, "San Jose")
                XCTAssertEqual(reverseSearchAddressResult.addresses?.first?.address?.streetName, "North 2nd Street")
                XCTAssertEqual(reverseSearchAddressResult.addresses?.first?.address?.streetNumber, "21")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_reverseSearchAddressBatch_shouldReturnBatchedReverseSearchResults() {
        let sut = makeSUT()
        let operation = sut.reverseSearchAddressBatch(request: anyReverseSearchAddressBatchRequest())
        let expectation = expectation(description: "reverseSearchAddressBatch should return")

        operation.pollUntilDone { [self] result, _ in
            assertSuccessfulResult(result) { batchResult in
                XCTAssertEqual(batchResult?.batchSummary?.successfulRequests, 3)
                assertReverseSearchAddressBatchItemsAreValid(batchResult?.batchItems)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_reverseSearchCrossStreetAddress_shouldReturnReverseSearchCrossStreetResults() {
        let sut = makeSUT()
        let expectation = expectation(description: "reverseSearchCrossStreetAddress should return")

        sut.reverseSearchCrossStreetAddress(query: [37.337, -121.89]) { [self] result, _ in
            assertSuccessfulResult(result) { reverseSearchCrossStreetAddressResult in
                XCTAssertEqual(reverseSearchCrossStreetAddressResult.addresses?.first?.address?.countryCode, "US")
                XCTAssertEqual(reverseSearchCrossStreetAddressResult.addresses?.first?.address?.postalCode, "95113")
                XCTAssertEqual(reverseSearchCrossStreetAddressResult.addresses?.first?.address?.countrySubdivision, "CA")
                XCTAssertEqual(reverseSearchCrossStreetAddressResult.addresses?.first?.address?.municipality, "San Jose")
                XCTAssertEqual(reverseSearchCrossStreetAddressResult.addresses?.first?.address?.streetName, "South 2nd Street & North 2nd Street")
                XCTAssertNil(reverseSearchCrossStreetAddressResult.addresses?.first?.address?.streetNumber)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_searchStructuredAddress_shouldReturnSearchStructuredResults() {
        let sut = makeSUT()
        let options = SearchStructuredAddressOptions(
            countryCode: "US",
            streetNumber: "15127",
            streetName: "NE 24th Street",
            municipality: "Redmond",
            countrySubdivision: "WA",
            postalCode: "98052"
        )
        let expectation = expectation(description: "searchStructuredAddress should return")

        sut.searchStructuredAddress(options: options) { [self] result, _ in
            assertSuccessfulResult(result) { searchAddressResult in
                XCTAssertEqual(searchAddressResult.results?.first?.address?.countryCode, "US")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.postalCode, "98052")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.countrySubdivision, "WA")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.municipality, "Redmond")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.streetName, "Northeast 24th Street")
                XCTAssertEqual(searchAddressResult.results?.first?.address?.streetNumber, "15127")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_searchNearbyPointOfInterest_shouldReturnSearchResults() {
        let sut = makeSUT()
        let options = SearchNearbyPointOfInterestOptions(
            radiusInMeters: anyRadiusInMeters()
        )
        let expectation = expectation(description: "searchNearbyPointOfInterest should return")

        sut.searchNearbyPointOfInterest(lat: anyLat(), lon: anyLon(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { searchAddressResult in
                assertSearchAddressResultItems(searchAddressResult.results)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_searchPointOfInterest_shouldReturnSearchResults() {
        let sut = makeSUT()
        let maximumNumberOfResults: Int32 = 5
        let options = SearchPointOfInterestOptions(
            top: maximumNumberOfResults,
            lat: anyLat(),
            lon: anyLon(),
            radiusInMeters: anyRadiusInMeters()
        )
        let expectation = expectation(description: "searchPointOfInterest should return")

        sut.searchPointOfInterest(query: anySearchQuery(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { searchAddressResult in
                XCTAssertEqual(searchAddressResult.results?.count, Int(maximumNumberOfResults))
                assertSearchAddressResultItems(searchAddressResult.results)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_searchPointOfInterestCategory_shouldReturnSearchResults() {
        let sut = makeSUT()
        let maximumNumberOfResults: Int32 = 5
        let options = SearchPointOfInterestCategoryOptions(
            top: maximumNumberOfResults,
            lat: anyLat(),
            lon: anyLon(),
            radiusInMeters: anyRadiusInMeters()
        )
        let expectation = expectation(description: "searchPointOfInterestCategory should return")

        sut.searchPointOfInterestCategory(query: anyPOICategoryQuery(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { searchAddressResult in
                XCTAssertEqual(searchAddressResult.results?.count, Int(maximumNumberOfResults))
                assertSearchAddressResultItems(searchAddressResult.results)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getPointOfInterestCategoryTree_shouldPointOfInterestCategoryTreeResults() {
        let sut = makeSUT()
        let expectation = expectation(description: "getPointOfInterestCategoryTree should return")

        sut.getPointOfInterestCategoryTree() { [self] result, _ in
            assertSuccessfulResult(result) { pointOfInterestCategoryTreeResult in
                assertPOICategoriesAreValid(pointOfInterestCategoryTreeResult.categories)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getPolygon_shouldReturnPolygons() {
        let sut = makeSUT()
        let geometryIds = anyGeometryIds()
        let expectation = expectation(description: "getPolygon should return")

        sut.getPolygon(geometryIds: geometryIds) { [self] result, _ in
            assertSuccessfulResult(result) { polygonResult in
                XCTAssertEqual(polygonResult.polygons?.count, geometryIds.count)
                assertPolygonsAreValid(polygonResult.polygons)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_searchAlongRoute_shouldReturnSearchResults() {
        let sut = makeSUT()
        let maximumNumberOfResults: Int32 = 2
        let options = SearchAlongRouteOptions(
            top: maximumNumberOfResults
        )
        let expectation = expectation(description: "searchAlongRoute should return")

        sut.searchAlongRoute(
            request: anySearchAlongRouteRequest(),
            query: anySearchQuery(),
            maxDetourTime: anyMaxDetourTime(),
            options: options
        ) { [self] result, _ in
            assertSuccessfulResult(result) { searchAddressResult in
                XCTAssertEqual(searchAddressResult.results?.count, Int(maximumNumberOfResults))
                assertSearchAddressResultItems(searchAddressResult.results)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_searchInsideGeometry_shouldReturnSearchResults() throws {
        throw XCTSkip("the GeoJsonObject autogeneration is broken and miss `coordinates` property, thus the request fails")

        let sut = makeSUT()
        let maximumNumberOfResults: Int32 = 2
        let options = SearchInsideGeometryOptions(
            top: maximumNumberOfResults
        )
        let expectation = expectation(description: "searchInsideGeometry should return")

        sut.searchInsideGeometry(
            request: anySearchInsideGeometryRequest(),
            query: anySearchQuery(),
            options: options
        ) { [self] result, _ in
            assertSuccessfulResult(result) { searchAddressResult in
                XCTAssertEqual(searchAddressResult.results?.count, Int(maximumNumberOfResults))
                assertSearchAddressResultItems(searchAddressResult.results)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Helpers

    func makeSUT() -> SearchClient {
        SearchClient(credential: SharedTokenCredential("PUT_YOUR_SUBSCRIPTION_KEY_HERE"))
    }

    func assertSuccessfulResult<T>(_ result: Result<T, AzureError>, file: StaticString = #file, line: UInt = #line, successCompletion: (T) -> Void) {
        switch result {
        case .failure(let error):
            XCTFail(error.message, file: file, line: line)
        case .success(let result):
            successCompletion(result)
        }
    }

    func assertSearchAddressResultItems(_ searchAddressResultItems: [SearchAddressResultItem]?, file: StaticString = #file, line: UInt = #line) {
        guard let resultItems = searchAddressResultItems else {
            XCTFail("SearchAddressResultItems should not be nil", file: file, line: line)
            return
        }

        for item in resultItems {
            XCTAssertNotNil(item.address?.country, "Search address should have country", file: file, line: line)
        }
    }

    func assertSearchAddressBatchItemsAreValid(_ batchItems: [SearchAddressBatchItem]?, file: StaticString = #file, line: UInt = #line) {
        guard let batchItems = batchItems else {
            XCTFail("BatchItems should not be nil", file: file, line: line)
            return
        }

        for batchItem in batchItems {
            assertSearchAddressResultItems(batchItem.response?.results, file: file, line: line)
        }
    }

    func assertReverseSearchAddressBatchItemsAreValid(_ batchItems: [ReverseSearchAddressBatchItem]?, file: StaticString = #file, line: UInt = #line) {
        guard let batchItems = batchItems else {
            XCTFail("BatchItems should not be nil", file: file, line: line)
            return
        }

        for batchItem in batchItems {
            guard let searchAddresses = batchItem.response?.addresses else {
                XCTFail("Search addresses from batch item should not be nil", file: file, line: line)
                continue
            }

            for searchAddress in searchAddresses {
                XCTAssertNotNil(searchAddress.address?.country, "Search address should have country", file: file, line: line)
            }
        }
    }

    func assertPOICategoriesAreValid(_ categories: [PointOfInterestCategory]?, file: StaticString = #file, line: UInt = #line) {
        guard let categories = categories else {
            XCTFail("PointOfInterestCategories should not be nil", file: file, line: line)
            return
        }

        for category in categories {
            XCTAssertNotNil(category.name, "POICategory should have name", file: file, line: line)
        }
    }

    func assertPolygonsAreValid(_ polygons: [AzureMapsSearch.Polygon]?, file: StaticString = #file, line: UInt = #line) {
        guard let polygons = polygons else {
            XCTFail("Polygons should not be nil", file: file, line: line)
            return
        }

        for polygon in polygons {
            XCTAssertNotNil(polygon.geometryData, "Polygon should have geometry data", file: file, line: line)
        }
    }

    func anyLat() -> Double {
        47.606038
    }

    func anyLon() -> Double {
        -122.333345
    }

    func anyRadiusInMeters() -> Int32 {
        8046
    }

    func anySearchQuery() -> String {
        "burger"
    }

    func anyPOICategoryQuery() -> String {
        "atm"
    }

    func anyGeometryIds() -> [String] {
        [
            "00005557-4100-3c00-0000-0000596ae44e",
            "00004d30-3300-3c00-0000-00002672312a",
            "00004d30-3300-3c00-0000-000026723144",
            "00004d30-3300-3c00-0000-0000267230e4",
            "00005557-4100-2800-0000-00000bfadc1f"
        ]
    }

    func anyMaxDetourTime() -> Int32 {
        1000
    }

    func anyFuzzySearchBatchRequest() -> BatchRequest {
        BatchRequest(batchItems: [
            BatchRequestItem(query: "?query=atm&lat=47.639769&lon=-122.128362&radius=5000"),
            BatchRequestItem(query: "?query=Statue Of Liberty"),
            BatchRequestItem(query: "?query=Starbucks&lat=47.639769&lon=-122.128362&radius=5000")
        ])
    }

    func anySearchAddressBatchRequest() -> BatchRequest {
        BatchRequest(batchItems: [
            BatchRequestItem(query: "?query=400 Broad St, Seattle, WA 98109&limit=3"),
            BatchRequestItem(query: "?query=One, Microsoft Way, Redmond, WA 98052&limit=3"),
            BatchRequestItem(query: "?query=350 5th Ave, New York, NY 10118&limit=1")
        ])
    }

    func anyReverseSearchAddressBatchRequest() -> BatchRequest {
        BatchRequest(batchItems: [
            BatchRequestItem(query: "?query=48.858561,2.294911"),
            BatchRequestItem(query: "?query=47.639765,-122.127896&radius=5000&limit=2"),
            BatchRequestItem(query: "?query=47.621028,-122.348170")
        ])
    }

    func anySearchAlongRouteRequest() -> SearchAlongRouteRequest {
        SearchAlongRouteRequest(
            route: GeoJsonLineString(
                type: .geoJsonLineString,
                coordinates: [
                    [
                        -122.143035,
                        47.653536
                    ],
                    [
                        -122.187164,
                        47.617556
                    ],
                    [
                        -122.114981,
                        47.570599
                    ],
                    [
                        -122.132756,
                        47.654009
                    ]
                ]
            )
        )
    }

    func anySearchInsideGeometryRequest() -> SearchInsideGeometryRequest {
        SearchInsideGeometryRequest(
            geometry: GeoJsonObject(
                type: .geoJsonPolygon
                // FIXME: Uncomment when the GeoJsonObject autogeneration is fixed and it has `coordinates` property
//                coordinates: [
//                    [
//                        [
//                            -122.43576049804686,
//                            37.7524152343544
//                        ],
//                        [
//                            -122.43301391601562,
//                            37.70660472542312
//                        ],
//                        [
//                            -122.36434936523438,
//                            37.712059855877314
//                        ],
//                        [
//                            -122.43576049804686,
//                            37.7524152343544
//                        ]
//                    ]
//                ]
            )
        )
    }
}
