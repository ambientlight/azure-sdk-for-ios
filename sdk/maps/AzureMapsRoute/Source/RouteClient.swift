
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

public class RouteClient {
    private let service: Route
        
    public init(
        endpoint: URL? = nil,
        credential: TokenCredential,
        options: RouteClientOptions = RouteClientOptions()
    ) {
        service = try! RouteClientInternal(
            url: endpoint,
            authPolicy: SharedTokenCredentialPolicy(credential: credential, scopes: []),
            withOptions: options
        ).route
    }
    
    public func getRouteDirections(
        routePoints: String,
        format: ResponseFormat = .json,
        options: GetRouteDirectionsOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<RouteDirections>
    ) {
        service.getRouteDirections(format: format, routePoints: routePoints, withOptions: options, completionHandler: completionHandler)
    }

    public func getRouteDirections(
        routePoints: String,
        additionalParameters: RouteDirectionParameters,
        format: ResponseFormat = .json,
        options: GetRouteDirectionsWithAdditionalParametersOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<RouteDirections>
    ) {
        service.get(routeDirectionsWithAdditionalParameters: additionalParameters, format: format, routePoints: routePoints, withOptions: options, completionHandler: completionHandler)
    }

    public func requestRouteDirectionsBatchSync(
        request: BatchRequest,
        format: JsonFormat = .json,
        options: RequestRouteDirectionsBatchSyncOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<RouteDirectionsBatchResult>
    ) {
        service.request(routeDirectionsBatchSync: request, format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func requestRouteDirectionsBatch(
        request: BatchRequest,
        format: JsonFormat = .json,
        options: RequestRouteDirectionsBatchOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<RouteDirectionsBatchResult?>
    ) {
        service.request(routeDirectionsBatch: request, format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func getRouteDirectionsBatch(
        batchId: String,
        options: GetRouteDirectionsBatchOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<RouteDirectionsBatchResult?>
    ) {
        service.getRouteDirectionsBatch(batchId: batchId, withOptions: options, completionHandler: completionHandler)
    }

    public func getRouteRange(
        query: [Double],
        format: ResponseFormat = .json,
        options: GetRouteRangeOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<RouteRangeResult>
    ) {
        service.getRouteRange(format: format, query: query, withOptions: options, completionHandler: completionHandler)
    }

    public func requestRouteMatrixSync(
        query: RouteMatrixQuery,
        format: JsonFormat = .json,
        options: RequestRouteMatrixSyncOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<RouteMatrixResult>
    ) {
        service.request(routeMatrixSync: query, format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func requestRouteMatrix(
        query: RouteMatrixQuery,
        format: JsonFormat = .json,
        options: RequestRouteMatrixOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<RouteMatrixResult?>
    ) {
        service.request(routeMatrix: query, format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func getRouteMatrix(
        matrixId: String,
        options: GetRouteMatrixOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<RouteMatrixResult?>
    ) {
        service.getRouteMatrix(matrixId: matrixId, withOptions: options, completionHandler: completionHandler)
    }
}
