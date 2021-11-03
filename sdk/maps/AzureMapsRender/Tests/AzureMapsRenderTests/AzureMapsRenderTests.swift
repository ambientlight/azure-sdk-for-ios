
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
@testable import AzureMapsRender

final class AzureMapsRenderTests: XCTestCase {
    func testGetMapTile(){
        let client = try! RenderClient(credential: SharedTokenCredential(""), withOptions: RenderClientOptions(apiVersion: .latest))
        let expectation = expectation(description: "should return")
        client.getMapTile(
            tilesetId: .microsoftBaseDarkgrey,
            tileIndex: TileIndex(z: 6, x: 10, y: 22),
            withOptions: GetMapTileV2Options(tileSize: .size512, language: "en-US")
        ){ result, response in
            switch (result, response) {
            case (.failure(let error), _):
                XCTFail(error.message)
            case (.success(_), Optional.some(let response)):
                let image = NSImage(data: response.data!)
                XCTAssertEqual(image?.size.width, 512)
                XCTAssertEqual(image?.size.height, 512)
            default:
                XCTFail("No response")
            }

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
