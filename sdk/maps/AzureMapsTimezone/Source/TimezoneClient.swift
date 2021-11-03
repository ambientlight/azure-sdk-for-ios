
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
        withOptions options: TimezoneClientOptions
    ) throws {
        self.service = try TimezoneClientInternal(
            url: nil,
            authPolicy: SharedTokenCredentialPolicy(credential: credential, scopes: []),
            withOptions: options
        ).timezone
    }
    
    public func getTimezoneById(
        timezoneId: String,
        withOptions options: GetTimezoneByIDOptions? = nil, completionHandler: @escaping HTTPResultHandler<TimezoneResult>
    ) {
        self.service.getTimezoneById(format: .json, timezoneId: timezoneId, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getTimezoneByCoordinates(
        coordinates: [Double],
        withOptions options: GetTimezoneByCoordinatesOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<TimezoneResult>
    ) {
        self.service.getTimezoneByCoordinates(format: .json, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getWindowsTimezoneIds(
        withOptions options: GetWindowsTimezoneIdsOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<[TimezoneWindows]>
    ) {
        self.service.getWindowsTimezoneIds(format: .json, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getIanaTimezoneIds(
        withOptions options: GetIanaTimezoneIdsOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<[IanaId]>
    ) {
        self.service.getIanaTimezoneIds(format: .json, withOptions: options, completionHandler: completionHandler)
    }
    
    public func getIanaVersion(
        withOptions options: GetIanaVersionOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<TimezoneIanaVersionResult>
    ) {
        self.service.getIanaVersion(format: .json, withOptions: options, completionHandler: completionHandler)
    }
    
    public func convertWindowsTimezoneToIana(
        windowsTimezoneId: String,
        withOptions options: ConvertWindowsTimezoneToIanaOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<[IanaId]>
    ) {
        self.service.convertWindowsTimezoneToIana(format: .json, windowsTimezoneId: windowsTimezoneId, withOptions: options, completionHandler: completionHandler)
    }
}
