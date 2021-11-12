
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

public class TrafficClient {
    private let service: Traffic
    
    public init(
        endpoint: URL? = nil,
        credential: TokenCredential,
        options: TrafficClientOptions = TrafficClientOptions()
    ) {
        service = try! TrafficClientInternal(
            url: endpoint,
            authPolicy: SharedTokenCredentialPolicy(credential: credential, scopes: []),
            withOptions: options
        ).traffic
    }

    public func getTrafficFlowSegment(
        style: TrafficFlowSegmentStyle,
        zoom: Int32,
        coordinates: [Double],
        format: ResponseFormat = .json,
        options: GetTrafficFlowSegmentOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<TrafficFlowSegmentData>
    ) {
        service.getTrafficFlowSegment(format: format, style: style, zoom: zoom, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }

    public func getTrafficFlowTile(
        style: TrafficFlowTileStyle,
        zoom: Int32,
        tileIndex: TileIndex,
        format: TileFormat = .png,
        options: GetTrafficFlowTileOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        service.getTrafficFlowTile(format: format, style: style, zoom: zoom, tileIndex: tileIndex, withOptions: options, completionHandler: completionHandler)
    }

    public func getTrafficIncidentDetail(
        style: IncidentDetailStyle,
        zoom: Int32,
        boundingBox: [Double],
        boundingZoom: Int32,
        trafficModelId: String,
        format: ResponseFormat = .json,
        options: GetTrafficIncidentDetailOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<TrafficIncidentDetail>
    ) {
        service.getTrafficIncidentDetail(format: format, style: style, boundingbox: boundingBox, boundingZoom: boundingZoom, trafficmodelid: trafficModelId, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getTrafficIncidentTile(
        style: TrafficIncidentTileStyle,
        zoom: Int32,
        tileIndex: TileIndex,
        format: TileFormat = .png,
        options: GetTrafficIncidentTileOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        service.getTrafficIncidentTile(format: format, style: style, zoom: zoom, tileIndex: tileIndex, withOptions: options, completionHandler: completionHandler)
    }

    public func getTrafficIncidentViewport(
        boundingBox: [Double],
        boundingZoom: Int32,
        overviewBox: [Double],
        overviewZoom: Int32,
        format: ResponseFormat = .json,
        options: GetTrafficIncidentViewportOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<TrafficIncidentViewport>
    ) {
        service.getTrafficIncidentViewport(format: format, boundingbox: boundingBox, boundingzoom: boundingZoom, overviewbox: overviewBox, overviewzoom: overviewZoom, withOptions: options, completionHandler: completionHandler)
    }
}
