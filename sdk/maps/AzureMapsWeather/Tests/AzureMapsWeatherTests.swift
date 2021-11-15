
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

import XCTest
import Foundation
import AzureCore
import AzureMapsWeather

final class AzureMapsWeatherTests: XCTestCase {
    func test_getCurrentConditions_shouldReturnCurrentConditions() {
        let sut = makeSUT()
        let options = GetCurrentConditionsOptions(
            unit: anyUnit(),
            details: "true",
            language: anyLanguage()
        )
        let expectation = expectation(description: "getCurrentConditions should return")

        sut.getCurrentConditions(coordinates: anyCoordinates(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { currentConditionsResponse in
                XCTAssertNotNil(currentConditionsResponse.results?.first?.dateTime)
                XCTAssertNotNil(currentConditionsResponse.results?.first?.uvIndex)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getDailyForecast_shouldReturnDailyForecast() {
        let sut = makeSUT()
        let options = GetDailyForecastOptions(
            unit: anyUnit(),
            duration: anyDuration(),
            language: anyLanguage()
        )
        let expectation = expectation(description: "getDailyForecast should return")

        sut.getDailyForecast(coordinates: anyCoordinates(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { dailyForecastResponse in
                XCTAssertNotNil(dailyForecastResponse.forecasts?.first?.dateTime)
                XCTAssertNotNil(dailyForecastResponse.forecasts?.first?.hoursOfSun)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getDailyIndices_shouldReturnDailyIndices() {
        let sut = makeSUT()
        let options = GetDailyIndicesOptions(
            language: anyLanguage(),
            duration: anyDuration(),
            indexGroupId: anyIndexGroupId()
        )
        let expectation = expectation(description: "getDailyIndices should return")

        sut.getDailyIndices(coordinates: anyCoordinates(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { dailyIndicesResponse in
                XCTAssertNotNil(dailyIndicesResponse.results?.first?.dateTime)
                XCTAssertNotNil(dailyIndicesResponse.results?.first?.value)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getHourlyForecast_shouldReturnHourlyForecast() {
        let sut = makeSUT()
        let options = GetHourlyForecastOptions(
            unit: anyUnit(),
            duration: anyDuration(),
            language: anyLanguage()
        )
        let expectation = expectation(description: "getHourlyForecast should return")

        sut.getHourlyForecast(coordinates: anyCoordinates(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { hourlyForecastResponse in
                XCTAssertNotNil(hourlyForecastResponse.forecasts?.first?.dateTime)
                XCTAssertNotNil(hourlyForecastResponse.forecasts?.first?.uvIndex)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getMinuteForecast_shouldReturnMinuteForecast() {
        let sut = makeSUT()
        let options = GetMinuteForecastOptions(
            interval: anyInterval(),
            language: anyLanguage()
        )
        let expectation = expectation(description: "getMinuteForecast should return")

        sut.getMinuteForecast(coordinates: anyCoordinates(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { minuteForecastResponse in
                XCTAssertNotNil(minuteForecastResponse.intervals?.first?.minute)
                XCTAssertNotNil(minuteForecastResponse.intervals?.first?.cloudCover)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getQuarterDayForecast_shouldReturnQuarterDayForecast() {
        let sut = makeSUT()
        let options = GetQuarterDayForecastOptions(
            unit: anyUnit(),
            duration: anyDuration(),
            language: anyLanguage()
        )
        let expectation = expectation(description: "getQuarterDayForecast should return")

        sut.getQuarterDayForecast(coordinates: anyCoordinates(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { quarterDayForecastResponse in
                XCTAssertNotNil(quarterDayForecastResponse.forecasts?.first?.dateTime)
                XCTAssertNotNil(quarterDayForecastResponse.forecasts?.first?.temperature?.maximum)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getSevereWeatherAlerts_shouldReturnSevereWeatherAlerts() {
        let sut = makeSUT()
        let options = GetSevereWeatherAlertsOptions(
            language: anyLanguage(),
            details: "true"
        )
        let expectation = expectation(description: "getSevereWeatherAlerts should return")

        sut.getSevereWeatherAlerts(coordinates: anyCoordinates(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { severeWeatherAlertsResponse in
                XCTAssertNotNil(severeWeatherAlertsResponse.results?.first?.category)
                XCTAssertNotNil(severeWeatherAlertsResponse.results?.first?.alertId)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func test_getWeatherAlongRoute_shouldReturnWeatherAlongRoute() {
        let sut = makeSUT()
        let options = GetWeatherAlongRouteOptions(
            language: anyLanguage()
        )
        let expectation = expectation(description: "getWeatherAlongRoute should return")

        sut.getWeatherAlongRoute(query: anyQuery(), options: options) { [self] result, _ in
            assertSuccessfulResult(result) { weatherAlongRouteResponse in
                XCTAssertNotNil(weatherAlongRouteResponse.waypoints?.first?.temperature?.value)
                XCTAssertNotNil(weatherAlongRouteResponse.waypoints?.first?.cloudCover)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Helpers

    func makeSUT() -> WeatherClient {
        // FIXME: replace with env variables
        WeatherClient(credential: SharedTokenCredential("PUT_YOUR_SUBSCRIPTION_KEY_HERE"))
    }

    func assertSuccessfulResult<T>(_ result: Result<T, AzureError>, file: StaticString = #file, line: UInt = #line, successCompletion: (T) -> Void) {
        switch result {
        case .failure(let error):
            XCTFail(error.message, file: file, line: line)
        case .success(let result):
            successCompletion(result)
        }
    }

    func anyCoordinates() -> [Double] {
        [47.641268,-122.125679]
    }

    func anyUnit() -> WeatherDataUnit {
        .metric
    }

    func anyLanguage() -> String {
        "EN"
    }

    func anyDuration() -> Int32 {
        1
    }

    func anyIndexGroupId() -> Int32 {
        11
    }

    func anyInterval() -> Int32 {
        15
    }

    func anyQuery() -> String {
        "38.907,-77.037,0:38.907,-77.009,10:38.926,-76.928,20:39.033,-76.852,30:39.168,-76.732,40:39.269,-76.634,50:39.287,-76.612,60"
    }
}
