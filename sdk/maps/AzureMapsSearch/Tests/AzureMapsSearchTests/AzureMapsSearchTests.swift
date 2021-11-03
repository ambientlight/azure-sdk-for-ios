
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
@testable import AzureMapsSearch

final class AzureMapsSearchTests: XCTestCase {
    func testFuzzySearch(){
        let client = try! SearchClient(credential: SharedTokenCredential(""), withOptions: SearchClientOptions())
        let expectation = expectation(description: "should return")
        client.fuzzySearch(query: "Seattle") { result, response in
            switch result {
            case .failure(let error):
                XCTFail(error.message)
            case .success(let result):
                XCTAssertEqual(result.results?.first?.address?.countryCode, "US")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFuzzyBatchSearch(){
        let client = try! SearchClient(credential: SharedTokenCredential(""), withOptions: SearchClientOptions())
        let expectation = expectation(description: "should return")
        let operation = client.fuzzy(searchBatch: BatchRequest.init(batchItems: [
            BatchRequestItem(query: "?query=atm&lat=47.639769&lon=-122.128362&radius=5000"),
            BatchRequestItem(query: "?query=Statue Of Liberty"),
            BatchRequestItem(query: "?query=Starbucks&lat=47.639769&lon=-122.128362&radius=5000")
        ]))
        
        operation.pollUntilDone { result, response in
            switch result {
            case .failure(let error):
                XCTFail(error.message)
            case .success(let result):
                XCTAssertEqual(result?.batchSummary?.successfulRequests, 3)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
