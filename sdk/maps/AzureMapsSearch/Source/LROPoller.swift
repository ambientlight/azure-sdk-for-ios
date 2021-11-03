//
//  File.swift
//  
//
//  Created by Azure Maps on 11/3/21.
//

import AzureCore
import Foundation

public class LROPoller<PollingResultType: Decodable, OptionsType: RequestOptions> {
    public enum Status {
        case notStarted
        case running
        case succeeded
        case failed
        case cancelled
        
        public var done: Bool {
            return self == .succeeded || self == .failed || self == .cancelled
        }
    }
    
    private let client: SearchClientInternal
    private let baseRequest: (@escaping HTTPResultHandler<PollingResultType?>) -> Void
    private let options: OptionsType?
    private var backoff: DispatchSourceTimer? = nil
    
    public private(set) var status: Status = .notStarted
    public var isDone: Bool {
        return self.status.done
    }
    
    internal init(client: SearchClientInternal, withOptions options: OptionsType?, baseRequest: @escaping (@escaping HTTPResultHandler<PollingResultType?>) -> Void) {
        self.client = client
        self.options = options
        self.baseRequest = baseRequest
    }
    
    internal func processLongRunningRequest(
        milliseconds: Int,
        locationURL: URL,
        response: HTTPResponse?,
        completionHandler: @escaping HTTPResultHandler<PollingResultType?>
    ) {
        let dispatchQueue = options?.dispatchQueue ?? client.commonOptions.dispatchQueue ?? DispatchQueue.main
        let params = RequestParameters(
            (.header, "x-ms-client-id", client.clientId, .encode),
            (.header, "Content-Type", "application/json", .encode),
            (.header, "Accept", "application/json", .encode)
        )
        
        guard let request = try? HTTPRequest(method: .get, url: locationURL, headers: params.headers)
        else {
            completionHandler(.failure(AzureError.client("Failed to construct LRO status HTTP request", nil)), response)
            return
        }
        
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200, 202] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context){ result, response in
            if case .success(let data) = result, response?.statusCode == 200, let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(PollingResultType.self, from: data)
                    dispatchQueue.async {
                        self.status = .succeeded
                        completionHandler(.success(decoded), response)
                    }
                } catch {
                    dispatchQueue.async {
                        self.status = .failed
                        completionHandler(.failure(AzureError.client("Decoding error.", error)), response)
                    }
                }
            } else if case .success(_) = result, response?.statusCode == 202 {
                let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
                timer.setEventHandler {
                    self.processLongRunningRequest(milliseconds: milliseconds, locationURL: locationURL, response: response, completionHandler: completionHandler)
                }
                timer.schedule(deadline: .now() + .milliseconds(milliseconds))
                timer.resume()
                self.backoff = timer
            } else {
                self.status = .failed
                completionHandler(.failure(AzureError.client("LRO failure")), response)
            }
        }
    }
    
    public func pollUntilDone(milliseconds: Int = 1000, completionHandler: @escaping HTTPResultHandler<PollingResultType?>){
        self.baseRequest() { result, response in
            switch result {
            case .success(_) where response?.statusCode == 202:
                guard let locationString = response?.headers["Location"],
                      let locationURL = URL(string: locationString)
                else {
                    completionHandler(.failure(AzureError.client("Long-running operation was accepted, but location header is missing or invalid in the response", nil)), response)
                    return
                }
                
                self.processLongRunningRequest(milliseconds: milliseconds, locationURL: locationURL, response: response, completionHandler: completionHandler)
            default:
                completionHandler(result, response)
            }
        }
    }
    
    public func cancel(){
        self.backoff?.cancel()
        self.status = .cancelled
    }
}
