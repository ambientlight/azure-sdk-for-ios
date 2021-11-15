
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
        options: SearchClientOptions = SearchClientOptions()
    ) {
        service = try! SearchClientInternal(
            url: endpoint,
            authPolicy: SharedTokenCredentialPolicy(credential: credential, scopes: []),
            withOptions: options
        ).search
    }
    
    public func fuzzySearch(
        query: String,
        format: ResponseFormat = .json,
        options: FuzzySearchOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SearchAddressResult>
    ) {
        service.fuzzySearch(format: format, query: query, withOptions: options, completionHandler: completionHandler)
    }
    
    
    
    public func fuzzySearchBatch(
        request: BatchRequest,
        format: JsonFormat = .json,
        options: FuzzySearchBatchOptions? = nil
    ) -> LROPoller<SearchAddressBatchProcessResult, FuzzySearchBatchOptions> {
        LROPoller(client: service.client, withOptions: options) { [self] (completionHandler: @escaping HTTPResultHandler<SearchAddressBatchProcessResult?>) in
            service.fuzzy(searchBatch: request, format: format, withOptions: options, completionHandler: completionHandler)
        }
    }

    public func searchAddress(
        query: String,
        format: ResponseFormat = .json,
        options: SearchAddressOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SearchAddressResult>
    ) {
        service.searchAddress(format: format, query: query, withOptions: options, completionHandler: completionHandler)
    }

    public func searchAddressBatch(
        request: BatchRequest,
        format: JsonFormat = .json,
        options: SearchAddressBatchOptions? = nil
    ) -> LROPoller<SearchAddressBatchProcessResult, SearchAddressBatchOptions> {
        LROPoller(client: service.client, withOptions: options) { [self] completionHandler in
            service.search(addressBatch: request, format: format, withOptions: options, completionHandler: completionHandler)
        }
    }

    public func reverseSearchAddress(
        query: [Double],
        format: ResponseFormat = .json,
        options: ReverseSearchAddressOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<ReverseSearchAddressResult>
    ) {
        service.reverseSearchAddress(format: format, query: query, withOptions: options, completionHandler: completionHandler)
    }

    public func reverseSearchAddressBatch(
        request: BatchRequest,
        format: JsonFormat = .json,
        options: ReverseSearchAddressBatchOptions? = nil
    ) -> LROPoller<ReverseSearchAddressBatchProcessResult, ReverseSearchAddressBatchOptions> {
        LROPoller(client: service.client, withOptions: options) { [self] completionHandler in
            service.reverse(searchAddressBatch: request, format: format, withOptions: options, completionHandler: completionHandler)
        }
    }

    public func reverseSearchCrossStreetAddress(
        query: [Double],
        format: ResponseFormat = .json,
        options: ReverseSearchCrossStreetAddressOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<ReverseSearchCrossStreetAddressResult>
    ) {
        service.reverseSearchCrossStreetAddress(format: format, query: query, withOptions: options, completionHandler: completionHandler)
    }

    public func searchStructuredAddress(
        format: ResponseFormat = .json,
        options: SearchStructuredAddressOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SearchAddressResult>
    ) {
        service.searchStructuredAddress(format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func searchNearbyPointOfInterest(
        lat: Double,
        lon: Double,
        format: ResponseFormat = .json,
        options: SearchNearbyPointOfInterestOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SearchAddressResult>
    ) {
        service.searchNearbyPointOfInterest(format: format, lat: lat, lon: lon, withOptions: options, completionHandler: completionHandler)
    }

    public func searchPointOfInterest(
        query: String,
        format: ResponseFormat = .json,
        options: SearchPointOfInterestOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SearchAddressResult>
    ) {
        service.searchPointOfInterest(format: format, query: query, withOptions: options, completionHandler: completionHandler)
    }

    public func searchPointOfInterestCategory(
        query: String,
        format: ResponseFormat = .json,
        options: SearchPointOfInterestCategoryOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SearchAddressResult>
    ) {
        service.searchPointOfInterestCategory(format: format, query: query, withOptions: options, completionHandler: completionHandler)
    }

    public func getPointOfInterestCategoryTree(
        format: JsonFormat = .json,
        options: GetPointOfInterestCategoryTreeOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<PointOfInterestCategoryTreeResult>
    ) {
        service.getPointOfInterestCategoryTree(format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func getPolygon(
        geometryIds: [String],
        format: JsonFormat = .json,
        options: GetPolygonOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<PolygonResult>
    ) {
        service.getPolygon(format: format, geometryIds: geometryIds, withOptions: options, completionHandler: completionHandler)
    }

    public func searchAlongRoute(
        request: SearchAlongRouteRequest,
        query: String,
        maxDetourTime: Int32,
        format: ResponseFormat = .json,
        options: SearchAlongRouteOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SearchAddressResult>
    ) {
        service.search(alongRoute: request, format: format, query: query, maxDetourTime: maxDetourTime, withOptions: options, completionHandler: completionHandler)
    }

    public func searchInsideGeometry(
        request: SearchInsideGeometryRequest,
        query: String,
        format: ResponseFormat = .json,
        options: SearchInsideGeometryOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SearchAddressResult>
    ) {
        service.search(insideGeometry: request, format: format, query: query, withOptions: options, completionHandler: completionHandler)
    }
}
