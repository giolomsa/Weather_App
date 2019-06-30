//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Gio Lomsa on 6/25/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    
    let httpLayer = HTTPLayer()
    let mainViewModel = MainViewModel()
    
    override func setUp() {
        mainViewModel.getWeatherFromServer()
        mainViewModel.currentCityWeather = nil
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherLoadingByCityID(){
        let expectation = XCTestExpectation(description: "Get weather by city ID")
        httpLayer.request(at: .weatherByCityId("2643743"), isIcon: false) { (data, response, error) in
            
            XCTAssertNil(error, "Error while loading cityById")
            XCTAssertNotNil(data, "Error while loading cityById - data is nil!")
            if let httpResponse = response as? HTTPURLResponse{
                XCTAssert(httpResponse.statusCode.isSuccessHTTPCode, "Response wasn't success")
            }else{
                XCTAssertNotNil(nil, "HttpResponse is not walid")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testWeatherLoadingByLocation(){
        let expectation = XCTestExpectation(description: "Get weather by Location")
        httpLayer.request(at: .weatherByGeographicCoordinates(55, 55), isIcon: false) { (data, response, error) in
            
            XCTAssertNil(error, "Error while loading weather by location")
            XCTAssertNotNil(data, "Error while loading weather by Location - data is nil!")
            if let httpResponse = response as? HTTPURLResponse{
                XCTAssert(httpResponse.statusCode.isSuccessHTTPCode, "Response wasn't success")
            }else{
                XCTAssertNotNil(nil, "HttpResponse is not walid")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testIconLoading(){
        let expectation = XCTestExpectation(description: "Load weather icon")
        httpLayer.request(at: .weatherIcon("01n"), isIcon: true) { (data, response, error) in
            
            XCTAssertNil(error, "Error while loading weather Icon")
            XCTAssertNotNil(data, "Error while loading weather Icon - Icon is nil!")
            if let httpResponse = response as? HTTPURLResponse{
                XCTAssert(httpResponse.statusCode.isSuccessHTTPCode, "Response wasn't success")
            }else{
                XCTAssertNotNil(nil, "HttpResponse is not walid")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
