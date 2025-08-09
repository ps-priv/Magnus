import Combine
import Foundation
import XCTest

@testable import MagnusDomain
@testable import MagnusFeatures

final class NewsNetworkServiceTests: XCTestCase {
    private var sut: NewsNetworkService!
    private var networkService: NetworkService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        let testConfig = NetworkConfiguration(
            baseURL: "https://nncv2-dev.serwik.pl",
            timeoutInterval: 10.0
        )
        networkService = NetworkService(configuration: testConfig)
        sut = NewsNetworkService(networkService: networkService)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        sut = nil
        networkService = nil
        cancellables = nil
        super.tearDown()
    }

    func test_getNewsById_withValidToken_shouldReturnNewsDetails() {
        // Given
        let token = "2|66fKHpecgmzYXjsd8Tqrs7ysWCrAvofXUCxY1pv421b1453f"
        let newsId = "eyJpZCI6MSwidG9rZW4iOiIzfGpwZ3gwRTFEdGh4RDA2cGdNRlJOeHJGdVNuTVdjTERzUWhjM0hYaVE0NzI4NzA3OCJ9"
        let expectation = XCTestExpectation(description: "getNewsById should complete")
        var receivedResponse: NewsDetails?
        var receivedError: Error?

        // When
        sut.getNewsById(token: token, id: newsId)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { response in
                    receivedResponse = response
                    print("Received NewsDetails: \(response)")
                }
            )
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 15.0)

        // The API is working and returning valid data, so we expect a successful response
        XCTAssertNil(receivedError, "Expected no error, but got: \(receivedError?.localizedDescription ?? "unknown error")")
        XCTAssertNotNil(receivedResponse, "Expected a NewsDetails but got nil")
        
        // Verify the response contains expected data
        if let response = receivedResponse {
            XCTAssertEqual(response.id, newsId, "Expected news ID to match")
            XCTAssertFalse(response.title.isEmpty, "Expected non-empty title")
            XCTAssertFalse(response.description.isEmpty, "Expected non-empty description")
            XCTAssertNotNil(response.author, "Expected author information")
            XCTAssertNotNil(response.publish_date, "Expected publish date")
            XCTAssertGreaterThanOrEqual(response.read_count, 0, "Expected non-negative read count")
            XCTAssertGreaterThanOrEqual(response.reactions_count, 0, "Expected non-negative reactions count")
            XCTAssertGreaterThanOrEqual(response.comments_count, 0, "Expected non-negative comments count")
        }
    }

    func test_getNewsById_withInvalidId_shouldThrowError() {
        // Given
        let token = "2|66fKHpecgmzYXjsd8Tqrs7ysWCrAvofXUCxY1pv421b1453f"
        let invalidNewsId = "999999" // Assuming this ID doesn't exist
        let expectation = XCTestExpectation(description: "getNewsById should complete with error")
        var receivedError: Error?

        // When
        sut.getNewsById(token: token, id: invalidNewsId)
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

        // We expect an error for invalid news ID
        XCTAssertNotNil(receivedError, "Expected error for invalid news ID")
    }

    func test_getNewsById_withEmptyToken_shouldThrowError() {
        // Given
        let emptyToken = ""
        let newsId = "1"
        let expectation = XCTestExpectation(description: "getNewsById should complete with error")
        var receivedError: Error?

        // When
        sut.getNewsById(token: emptyToken, id: newsId)
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

        // We expect an error for empty token
        XCTAssertNotNil(receivedError, "Expected error for empty token")
    }

    func test_getNewsById_shouldReturnValidNewsDetailsStructure() {
        // Given
        let token = "2|66fKHpecgmzYXjsd8Tqrs7ysWCrAvofXUCxY1pv421b1453f"
        let newsId = "1"
        let expectation = XCTestExpectation(description: "getNewsById should complete")
        var receivedResponse: NewsDetails?

        // When
        sut.getNewsById(token: token, id: newsId)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error: \(error)")
                    }
                    expectation.fulfill()
                },
                receiveValue: { response in
                    receivedResponse = response
                }
            )
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 15.0)

        // Verify all required fields are present
        if let response = receivedResponse {
            XCTAssertNotNil(response.id, "News ID should not be nil")
            XCTAssertNotNil(response.title, "News title should not be nil")
            XCTAssertNotNil(response.description, "News description should not be nil")
            XCTAssertNotNil(response.image, "News image should not be nil")
            XCTAssertNotNil(response.publish_date, "News publish date should not be nil")
            XCTAssertNotNil(response.author, "News author should not be nil")
            XCTAssertNotNil(response.tags, "News tags should not be nil")
            XCTAssertNotNil(response.groups, "News groups should not be nil")
            XCTAssertNotNil(response.comments, "News comments should not be nil")
            XCTAssertNotNil(response.reactions, "News reactions should not be nil")
            XCTAssertNotNil(response.read, "News read list should not be nil")
            XCTAssertNotNil(response.attachments, "News attachments should not be nil")
            
            // Verify author structure
            XCTAssertNotNil(response.author.id, "Author ID should not be nil")
            XCTAssertNotNil(response.author.name, "Author name should not be nil")
            
            // Verify numeric fields are valid
            XCTAssertGreaterThanOrEqual(response.highlight_entry, 0, "Highlight entry should be non-negative")
            XCTAssertGreaterThanOrEqual(response.block_comments, 0, "Block comments should be non-negative")
            XCTAssertGreaterThanOrEqual(response.block_reactions, 0, "Block reactions should be non-negative")
        } else {
            XCTFail("Expected NewsDetails response but got nil")
        }
    }

    func test_getNewsById_withDifferentIds_shouldReturnDifferentNews() {
        // Given
        let token = "8|ZYEdq6S4l9MZh00ul7ebfhAhZ8uyCjSbIZhuo7KIf9ded35b"
        let newsId1 = "1"
        let newsId2 = "2"
        let expectation1 = XCTestExpectation(description: "First getNewsById should complete")
        let expectation2 = XCTestExpectation(description: "Second getNewsById should complete")
        var response1: NewsDetails?
        var response2: NewsDetails?

        // When
        sut.getNewsById(token: token, id: newsId1)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error for news ID 1: \(error)")
                    }
                    expectation1.fulfill()
                },
                receiveValue: { response in
                    response1 = response
                }
            )
            .store(in: &cancellables)

        sut.getNewsById(token: token, id: newsId2)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error for news ID 2: \(error)")
                    }
                    expectation2.fulfill()
                },
                receiveValue: { response in
                    response2 = response
                }
            )
            .store(in: &cancellables)

        // Then
        wait(for: [expectation1, expectation2], timeout: 15.0)

        // Both requests should succeed and return different news
        XCTAssertNotNil(response1, "Expected first NewsDetails response")
        XCTAssertNotNil(response2, "Expected second NewsDetails response")
        
        if let news1 = response1, let news2 = response2 {
            XCTAssertEqual(news1.id, newsId1, "First news should have correct ID")
            XCTAssertEqual(news2.id, newsId2, "Second news should have correct ID")
            
            // If both news exist, they should be different
            if news1.id != news2.id {
                XCTAssertNotEqual(news1.title, news2.title, "Different news should have different titles")
            }
        }
    }
}
