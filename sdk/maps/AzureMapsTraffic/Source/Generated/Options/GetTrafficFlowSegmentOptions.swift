// --------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// --------------------------------------------------------------------------

import AzureCore
import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable identifier_name
// swiftlint:disable line_length

/// User-configurable options for the `GetTrafficFlowSegment` operation.
public struct GetTrafficFlowSegmentOptions: RequestOptions {
    /// Unit of speed in KMPH or MPH
    public let unit: SpeedUnit?
    /// The value of the width of the line representing traffic. This value is a multiplier and the accepted values range from 1 - 20. The default value is 10.
    public let thickness: Int32?
    /// Boolean on whether the response should include OpenLR code
    public let openLr: Bool?

    /// A client-generated, opaque value with 1KB character limit that is recorded in analytics logs.
    /// Highly recommended for correlating client-side activites with requests received by the server.
    public let clientRequestId: String?

    /// A token used to make a best-effort attempt at canceling a request.
    public let cancellationToken: CancellationToken?

    /// A dispatch queue on which to call the completion handler. Defaults to `DispatchQueue.main`.
    public var dispatchQueue: DispatchQueue?

    /// A `PipelineContext` object to associate with the request.
    public var context: PipelineContext?

    /// Initialize a `GetTrafficFlowSegmentOptions` structure.
    /// - Parameters:
    ///   - unit: Unit of speed in KMPH or MPH
    ///   - thickness: The value of the width of the line representing traffic. This value is a multiplier and the accepted values range from 1 - 20. The default value is 10.
    ///   - openLr: Boolean on whether the response should include OpenLR code
    ///   - clientRequestId: A client-generated, opaque value with 1KB character limit that is recorded in analytics logs.
    ///   - cancellationToken: A token used to make a best-effort attempt at canceling a request.
    ///   - dispatchQueue: A dispatch queue on which to call the completion handler. Defaults to `DispatchQueue.main`.
    ///   - context: A `PipelineContext` object to associate with the request.
    public init(
        unit: SpeedUnit? = nil,
        thickness: Int32? = nil,
        openLr: Bool? = nil,
        clientRequestId: String? = nil,
        cancellationToken: CancellationToken? = nil,
        dispatchQueue: DispatchQueue? = nil,
        context: PipelineContext? = nil
    ) {
        self.unit = unit
        self.thickness = thickness
        self.openLr = openLr
        self.clientRequestId = clientRequestId
        self.cancellationToken = cancellationToken
        self.dispatchQueue = dispatchQueue
        self.context = context
    }
}
