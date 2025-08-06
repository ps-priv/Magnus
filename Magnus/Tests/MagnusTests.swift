import Alamofire
import Combine
import Foundation
import XCTest

@testable import MagnusDomain
@testable import MagnusFeatures

final class MagnusTests: XCTestCase {
    func test_twoPlusTwo_isFour() {
        XCTAssertEqual(2 + 2, 4)
    }
}

final class DashboardNetworkServiceTests: XCTestCase {
    private var sut: DashboardNetworkService!
    private var networkService: NetworkService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        let testConfig = NetworkConfiguration(
            baseURL: "https://nncv2-dev.serwik.pl",
            timeoutInterval: 10.0
        )
        networkService = NetworkService(configuration: testConfig)
        sut = DashboardNetworkService(networkService: networkService)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        sut = nil
        networkService = nil
        cancellables = nil
        super.tearDown()
    }

    func test_getDashboardData_withValidToken_shouldMakeHTTPRequest() {
        // Given
        let token = "8|ZYEdq6S4l9MZh00ul7ebfhAhZ8uyCjSbIZhuo7KIf9ded35b"
        let expectation = XCTestExpectation(description: "getDashboardData should complete")
        var receivedResponse: DashboardResponse?
        var receivedError: Error?

        // When
        sut.getDashboardData(token: token)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { response in
                    receivedResponse = response
                    print("Received DashboardResponse: \(response)")
                }
            )
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 15.0)

        // The API is working and returning valid data, so we expect a successful response
        XCTAssertNil(receivedError, "Expected no error, but got: \(receivedError?.localizedDescription ?? "unknown error")")
        XCTAssertNotNil(receivedResponse, "Expected a DashboardResponse but got nil")
        
        // Verify the response contains expected data
        if let response = receivedResponse {
            XCTAssertFalse(response.news.isEmpty, "Expected news items in response")
            XCTAssertFalse(response.events.isEmpty, "Expected events in response")
            XCTAssertFalse(response.materials.isEmpty, "Expected materials in response")
            XCTAssertFalse(response.academy.isEmpty, "Expected academy items in response")
        }
    }

     func test_getDashboardData_withEmptyToken_shouldMakeHTTPRequestWithoutAuth() {
         // Given
         let token = ""
         let expectation = XCTestExpectation(description: "getDashboardData should complete")
         var receivedError: Error?

         // When
         sut.getDashboardData(token: token)
             .sink(
                 receiveCompletion: { completion in
                     if case .failure(let error) = completion {
                         receivedError = error
                     }
                     expectation.fulfill()
                 },
                 receiveValue: { _ in }
             )
             .store(in: &cancellables)

         // Then
         wait(for: [expectation], timeout: 15.0)

         // We expect a network error since httpbin.org won't return proper DashboardResponse
         // but this proves the real NetworkService is making HTTP requests
         print("Received error: \(receivedError?.localizedDescription ?? "unknown error")")

         if receivedError != nil {
             print("Error during request: \(receivedError!.localizedDescription)")
             print("Error status code: \((receivedError as? AFError)?.responseCode ?? 0)")
         }
         
         XCTAssertNotNil(receivedError)
     }

    // func test_getDashboardData_withInvalidBaseURL_shouldFailWithNetworkError() {
    //     // Given
    //     let invalidConfig = NetworkConfiguration(
    //         baseURL: "https://invalid-domain-that-does-not-exist.com",
    //         timeoutInterval: 5.0
    //     )
    //     let invalidNetworkService = NetworkService(configuration: invalidConfig)
    //     let invalidSut = DashboardNetworkService(networkService: invalidNetworkService)

    //     let token = "test-token"
    //     let expectation = XCTestExpectation(description: "getDashboardData should fail")
    //     var receivedError: Error?

    //     // When
    //     invalidSut.getDashboardData(token: token)
    //         .sink(
    //             receiveCompletion: { completion in
    //                 if case .failure(let error) = completion {
    //                     receivedError = error
    //                 }
    //                 expectation.fulfill()
    //             },
    //             receiveValue: { _ in }
    //         )
    //         .store(in: &cancellables)

    //     // Then
    //     wait(for: [expectation], timeout: 10.0)

    //     XCTAssertNotNil(receivedError)
    //     // Verify it's a network-related error
    //     if let afError = receivedError as? AFError {
    //         XCTAssertTrue(afError.isSessionTaskError || afError.isResponseValidationError)
    //     }
    // }
}
