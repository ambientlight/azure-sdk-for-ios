
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

public class WeatherClient {
    private let service: Weather
    
    public init(
        endpoint: URL? = nil,
        credential: TokenCredential,
        options: WeatherClientOptions = WeatherClientOptions()
    ) {
        service = try! WeatherClientInternal(
            url: endpoint,
            authPolicy: SharedTokenCredentialPolicy(credential: credential, scopes: []),
            withOptions: options
        ).weather
    }
    
    public func getCurrentConditions(
        coordinates: [Double],
        format: JsonFormat = .json,
        options: GetCurrentConditionsOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<CurrentConditionsResponse>
    ) {
        service.getCurrentConditions(format: format, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }

    public func getDailyForecast(
        coordinates: [Double],
        format: JsonFormat = .json,
        options: GetDailyForecastOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<DailyForecastResponse>
    ) {
        service.getDailyForecast(format: format, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }

    public func getDailyIndices(
        coordinates: [Double],
        format: JsonFormat = .json,
        options: GetDailyIndicesOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<DailyIndicesResponse>
    ) {
        service.getDailyIndices(format: format, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }

    public func getHourlyForecast(
        coordinates: [Double],
        format: JsonFormat = .json,
        options: GetHourlyForecastOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<HourlyForecastResponse>
    ) {
        service.getHourlyForecast(format: format, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }

    public func getMinuteForecast(
        coordinates: [Double],
        format: JsonFormat = .json,
        options: GetMinuteForecastOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<MinuteForecastResponse>
    ) {
        service.getMinuteForecast(format: format, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }

    public func getQuarterDayForecast(
        coordinates: [Double],
        format: JsonFormat = .json,
        options: GetQuarterDayForecastOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<QuarterDayForecastResponse>
    ) {
        service.getQuarterDayForecast(format: format, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }

    public func getSevereWeatherAlerts(
        coordinates: [Double],
        format: JsonFormat = .json,
        options: GetSevereWeatherAlertsOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<SevereWeatherAlertsResponse>
    ) {
        service.getSevereWeatherAlerts(format: format, coordinates: coordinates, withOptions: options, completionHandler: completionHandler)
    }

    public func getWeatherAlongRoute(
        query: String,
        format: JsonFormat = .json,
        options: GetWeatherAlongRouteOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<WeatherAlongRouteResponse>
    ) {
        service.getWeatherAlongRoute(format: format, query: query, withOptions: options, completionHandler: completionHandler)
    }
}
