
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

import AzureCore
import Foundation

public class SearchClient {
    private let service: Search
    
    public init(
        endpoint: URL? = nil,
        credential: TokenCredential,
        withOptions options: SearchClientOptions
    ) throws {
        self.service = try SearchClientInternal(
            url: nil,
            authPolicy: SharedTokenCredentialPolicy(credential: credential, scopes: []),
            withOptions: options
        ).search
    }
    
    public func fuzzySearch(
        query: String,
        withOptions options: FuzzySearchOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SearchAddressResult>
    ) {
        self.service.fuzzySearch(format: .json, query: query, withOptions: options, completionHandler: completionHandler)
    }
    
    
    
    public func fuzzy(
        searchBatch: BatchRequest,
        withOptions options: FuzzySearchBatchOptions? = nil
    ) -> LROPoller<SearchAddressBatchProcessResult, FuzzySearchBatchOptions> {
        return LROPoller(client: self.service.client, withOptions: options) { (completionHandler: @escaping HTTPResultHandler<SearchAddressBatchProcessResult?>) in
            self.service.fuzzy(searchBatch: searchBatch, format: .json, withOptions: options, completionHandler: completionHandler)
        }
    }
}
