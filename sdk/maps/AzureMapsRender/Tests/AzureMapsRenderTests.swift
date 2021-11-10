
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
import AzureMapsRender

final class AzureMapsRenderTests: XCTestCase {
    func test_getCopyrightCaption_shouldReturnCopyrightCaption() {
        let sut = makeSUT()
        let expectation = expectation(description: "should return")

        sut.getCopyrightCaption() { [self] result, _ in
            assertSuccessfulResult(result) { copyrightCaption in
                XCTAssertNotNil(copyrightCaption.copyrightsCaption)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getCopyrightForTile_shouldReturnCopyright() {
        let sut = makeSUT()
        let expectation = expectation(description: "should return")

        sut.getCopyrightForTile(tileIndex: anyTileIndex()) { [self] result, _ in
            assertResultHasCopyright(result)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getCopyrightForWorld_shouldReturnCopyright() {
        let sut = makeSUT()
        let expectation = expectation(description: "should return")

        sut.getCopyrightForWorld() { [self] result, _ in
            assertResultHasCopyright(result)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getCopyrightFromBoundingBox_shouldReturnCopyright() {
        let sut = makeSUT()
        let expectation = expectation(description: "should return")

        sut.getCopyrightFromBoundingBox(boundingBox: anyBoundingBox()) { [self] result, _ in
            assertResultHasCopyright(result)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getMapStaticImage_shouldReturnImage() {
        let sut = makeSUT()
        let expectation = expectation(description: "should return")

        sut.getMapStaticImage(
            options: GetMapStaticImageOptions(layer: .basic, style: .dark, zoom: anyZoom(), boundingBox: anyBounds())
        ) { [self] result, response in
            assertSuccessfulResult(result)
            assertResponseHasImageRepresentableData(response)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getMapAttribution_shouldReturnAttribution() {
        let sut = makeSUT()
        let expectation = expectation(description: "should return")

        sut.getMapAttribution(tilesetId: .microsoftBaseDarkgrey, zoom: anyZoom(), bounds: anyBounds()) { [self] result, _ in
            assertSuccessfulResult(result) { mapAttribution in
                XCTAssertNotNil(mapAttribution.copyrights)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getMapTileset_shouldReturnMapTileset() {
        let sut = makeSUT()
        let expectation = expectation(description: "should return")

        sut.getMapTileset(tilesetId: .microsoftBaseDarkgrey) { [self] result, _ in
            assertSuccessfulResult(result) { mapTileset in
                XCTAssertNotNil(mapTileset.name)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getMapStateTile_shouldReturnImage() throws {
        throw XCTSkip("Remove skipping as soon as tested with a proper stateset id")

        let sut = makeSUT()
        let expectation = expectation(description: "should return")

        sut.getMapStateTile(statesetId: "PUT_YOUR_STATESET_ID_HERE", tileIndex: anyTileIndex()) { [self] result, response in
            assertSuccessfulResult(result)
            assertResponseHasImageRepresentableData(response)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getMapTileV2_shouldReturnImage() {
        let sut = makeSUT()
        let expectation = expectation(description: "should return")

        sut.getMapTileV2(
            tilesetId: .microsoftBaseDarkgrey,
            tileIndex: anyTileIndex(),
            options: GetMapTileV2Options(tileSize: .size512, language: "en-US")
        ) { [self] result, response in
            assertSuccessfulResult(result)
            assertResponseHasImageRepresentableData(response)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Helpers

    func makeSUT() -> RenderClient {
        // FIXME: replace with env variables
        RenderClient(credential: SharedTokenCredential("PUT_YOUR_SUBSCRIPTION_KEY_HERE"))
    }

    func assertSuccessfulResult<T>(_ result: Result<T, AzureError>, file: StaticString = #file, line: UInt = #line, successCompletion: ((T) -> Void)? = nil) {
        switch result {
        case let .failure(error):
            XCTFail(error.message, file: file, line: line)
        case let .success(result):
            successCompletion?(result)
        }
    }

    func assertResultHasCopyright(_ result: Result<Copyright, AzureError>, file: StaticString = #file, line: UInt = #line) {
        switch result {
        case let .failure(error):
            XCTFail(error.message, file: file, line: line)
        case let .success(copyright):
            XCTAssertNotNil(copyright.generalCopyrights, file: file, line: line)
        }
    }

    func assertResponseHasImageRepresentableData(_ response: HTTPResponse?, file: StaticString = #file, line: UInt = #line) {
        if let response = response, let data = response.data {
            XCTAssertNotNil(NSImage(data: data), file: file, line: line)
        } else {
            XCTFail("No response or data", file: file, line: line)
        }
    }

    func anyZoom() -> Int32 {
        2
    }

    func anyBounds() -> [Double] {
        [1.355233, 42.982261, 24.980233, 56.526017]
    }

    func anyBoundingBox() -> BoundingBox {
        BoundingBox(southWest: [4.84228, 52.41064], northEast: [4.84239, 52.41072])
    }

    func anyTileIndex() -> TileIndex {
        TileIndex(z: 6, x: 10, y: 22)
    }
}
