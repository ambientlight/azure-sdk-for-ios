
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

public class TimezoneClient {
    private let service: Timezone
    
    public init(
        endpoint: URL? = nil,
        credential: TokenCredential,
        options: TimezoneClientOptions = TimezoneClientOptions()
    ) {
        service = try! TimezoneClientInternal(
            url: endpoint,
            authPolicy: SharedTokenCredentialPolicy(credential: credential, scopes: []),
            withOptions: options
        ).timezone
    }
    
    public func getTimezoneById(
        timezoneId: String,
        format: JsonFormat = .json,
        options: GetTimezoneByIDOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<TimezoneResult>
    ) {
        service.getTimezoneById(format: format, timezoneId: timezoneId, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getTimezoneByCoordinates(
        coordinates: [Double],
        format: JsonFormat = .json,
        options: GetTimezoneByCoordinatesOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<TimezoneResult>
    ) {
        service.getTimezoneByCoordinates(format: format, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getWindowsTimezoneIds(
        format: JsonFormat = .json,
        options: GetWindowsTimezoneIdsOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<[TimezoneWindows]>
    ) {
        service.getWindowsTimezoneIds(format: format, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getIanaTimezoneIds(
        format: JsonFormat = .json,
        options: GetIanaTimezoneIdsOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<[IanaId]>
    ) {
        service.getIanaTimezoneIds(format: format, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getIanaVersion(
        format: JsonFormat = .json,
        options: GetIanaVersionOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<TimezoneIanaVersionResult>
    ) {
        service.getIanaVersion(format: format, withOptions: options, completionHandler: completionHandler)
    }
    
    public func convertWindowsTimezoneToIana(
        windowsTimezoneId: String,
        format: JsonFormat = .json,
        options: ConvertWindowsTimezoneToIanaOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<[IanaId]>
    ) {
        service.convertWindowsTimezoneToIana(format: format, windowsTimezoneId: windowsTimezoneId, withOptions: options, completionHandler: completionHandler)
    }
}
