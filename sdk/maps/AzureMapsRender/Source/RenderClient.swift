
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

public class RenderClient {
    private let service: Render
    
    public init(
        endpoint: URL? = nil,
        credential: TokenCredential,
        options: RenderClientOptions = RenderClientOptions()
    ) {
        service = try! RenderClientInternal(
            url: endpoint,
            authPolicy: SharedTokenCredentialPolicy(credential: credential, scopes: []),
            withOptions: options
        ).render
    }

    public func getCopyrightCaption(
        format:  ResponseFormat = .json,
        options: GetCopyrightCaptionOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<CopyrightCaption>
    ) {
        service.getCopyrightCaption(format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func getCopyrightForTile(
        tileIndex: TileIndex,
        format:  ResponseFormat = .json,
        options: GetCopyrightForTileOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Copyright>
    ) {
        service.getCopyrightForTile(format: format, tileIndex: tileIndex, withOptions: options, completionHandler: completionHandler)
    }

    public func getCopyrightForWorld(
        format:  ResponseFormat = .json,
        options: GetCopyrightForWorldOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Copyright>
    ) {
        service.getCopyrightForWorld(format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func getCopyrightFromBoundingBox(
        boundingBox: BoundingBox,
        format:  ResponseFormat = .json,
        options: GetCopyrightFromBoundingBoxOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Copyright>
    ) {
        service.getCopyrightFromBoundingBox(format: format, boundingBox: boundingBox, withOptions: options, completionHandler: completionHandler)
    }

    public func getMapStaticImage(
        format:  RasterTileFormat = .png,
        options: GetMapStaticImageOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        service.getMapStaticImage(format: format, withOptions: options, completionHandler: completionHandler)
    }

    public func getMapAttribution(
        tilesetId: TilesetID,
        zoom: Int32,
        bounds: [Double],
        options: GetMapAttributionOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<MapAttribution>
    ) {
        service.getMapAttribution(tilesetId: tilesetId, zoom: zoom, bounds: bounds, withOptions: options, completionHandler: completionHandler)
    }

    public func getMapTileset(
        tilesetId: TilesetID,
        options: GetMapTilesetOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<MapTileset>
    ) {
        service.getMapTileset(tilesetId: tilesetId, withOptions: options, completionHandler: completionHandler)
    }

    public func getMapStateTile(
        statesetId: String,
        tileIndex: TileIndex,
        options: GetMapStateTileOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        service.getMapStateTile(statesetId: statesetId, tileIndex: tileIndex, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getMapTileV2(
        tilesetId: TilesetID,
        tileIndex: TileIndex,
        options: GetMapTileV2Options? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        service.getMapTileV2(tilesetId: tilesetId, tileIndex: tileIndex, withOptions: options, completionHandler: completionHandler)
    }
}

