
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

public class ElevationClient {
    private let service: Elevation
    
    public init(
        endpoint: URL? = nil,
        credential: TokenCredential,
        options: ElevationClientOptions = ElevationClientOptions()
    ) {
        service = try! ElevationClientInternal(
            url: endpoint,
            authPolicy: SharedTokenCredentialPolicy(credential: credential, scopes: []),
            withOptions: options
        ).elevation
    }
    
    public func getDataForBoundingBox(
        bounds: [Float],
        rows: Int32,
        columns: Int32,
        format: JsonFormat = .json,
        options: GetDataForBoundingBoxOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<ElevationResult>
    ) {
        service.getDataForBoundingBox(format: format, bounds: bounds, rows: rows, columns: columns, withOptions: options, completionHandler: completionHandler)
    }

    public func getDataForPoints(
        points: [String],
        format: JsonFormat = .json,
        options: GetDataForPointsOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<ElevationResult>
    ) {
        service.getDataForPoints(format: format, points: points, withOptions: options, completionHandler: completionHandler)
    }

    public func getDataForPolyline(
        lines: [String],
        format: JsonFormat = .json,
        options: GetDataForPolylineOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<ElevationResult>
    ) {
        service.getDataForPolyline(format: format, lines: lines, withOptions: options, completionHandler: completionHandler)
    }

    public func postDataForPoints(
        points: [LatLongPairAbbreviated],
        format: JsonFormat = .json,
        options: PostDataForPointsOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<ElevationResult>
    ) {
        service.post(dataForPoints: points, format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func postDataForPolyline(
        lines: [LatLongPairAbbreviated],
        format: JsonFormat = .json,
        options: PostDataForPolylineOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<ElevationResult>
    ) {
        service.post(dataForPolyline: lines, format: format, withOptions: options, completionHandler: completionHandler)
    }
}
