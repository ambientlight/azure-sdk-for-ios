
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

import Foundation
import AzureCore

internal class SharedTokenCredentialPolicy: Authenticating {
    // MARK: Properties

    internal var next: PipelineStage?

    private let scopes: [String]
    private let credential: TokenCredential

    // MARK: Initializers

    internal init(credential: TokenCredential, scopes: [String]) {
        self.scopes = scopes
        self.credential = credential
    }

    // MARK: Public Methods

    /// Authenticates an HTTP `PipelineRequest` with an OAuth token.
    /// - Parameters:
    ///   - request: A `PipelineRequest` object.
    ///   - completionHandler: A completion handler that forwards the modified pipeline request.
    internal func authenticate(request: PipelineRequest, completionHandler: @escaping OnRequestCompletionHandler) {
        credential.token(forScopes: scopes) { token, error in
            if let error = error {
                completionHandler(request, error)
                return
            }
            guard let token = token?.token else {
                completionHandler(request, AzureError.client("Token cannot be empty"))
                return
            }
            request.httpRequest.headers["Subscription-Key"] = token
            completionHandler(request, nil)
        }
    }
}
