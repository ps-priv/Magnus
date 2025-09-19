import Combine
import Foundation
import XCTest
import Alamofire

@testable import MagnusDomain
@testable import MagnusFeatures

final class AddNewsNetworkServiceTests: XCTestCase {
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

    func test_addNews_withValidToken_catch() {
        // Given
        let token = "96|OZTrSu8o8vhm80y1Z27imz93QsweRkPfi00UN2TLc79c3863"
        let expectation = XCTestExpectation(description: "addNews should complete")
        var receivedResponse: Void?
        var receivedError: Error?
        
        let tags = ["UnitTest", "iOS"]

        // When
        sut.addNews(token: token, title: "UnitTest News 1", content: "Jakiś długi tekst dfjklsdfjksdfjkl dfsjklsdjklsdfjk sdfjkldfjk dfjkldfsjklsdfjkl dsfjklsdfjklsdfjkl sdfjkjklsdfjklsdf dfjklsdfjkl dfldfjklsdfjkl sdfkljsdfjklsdfjkl sdfjklsdfjklsdfjkl dfjksdfjkl;sdfjklsdf", image: "", selectedGroups: [], attachments: [], tags: [], allowComments: false)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion,
                          let afError = error as? AFError {
                        receivedError = afError
                        print("AFError: \(afError)")
                          } else if case .failure(let error) = completion {
                              receivedError = error
                              print("Error: \(error)")
                          }
//                       let httpError = error as? HTTPError {
//                        print(httpError.statusCode)
//                    }
                },
                receiveValue: { _ in
                    receivedResponse = ()
                }
            )
            .store(in: &cancellables)

        
        print("Received Error: \(String(describing: receivedError))")
        // Then
        //wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(receivedError)
       // XCTAssertNotNil(receivedResponse)
    }
    
    func test_addNews_withValidToken_shouldReturnSuccess() {
        // Given
        let token = "96|OZTrSu8o8vhm80y1Z27imz93QsweRkPfi00UN2TLc79c3863"
        let expectation = XCTestExpectation(description: "addNews should complete")
        var receivedResponse: Void?
        var receivedError: Error?
        
        let tags = ["UnitTest", "iOS"]

        // When
        sut.addNews(token: token, title: "UnitTest News 1", content: "Jakiś długi tekst dfjklsdfjksdfjkl dfsjklsdjklsdfjk sdfjkldfjk dfjkldfsjklsdfjkl dsfjklsdfjklsdfjkl sdfjkjklsdfjklsdf dfjklsdfjkl dfldfjklsdfjkl sdfkljsdfjklsdfjkl sdfjklsdfjklsdfjkl dfjksdfjkl;sdfjklsdf", image: getBase64Image(), selectedGroups: [], attachments: [], tags: tags, allowComments: true)
            .sink(
                receiveCompletion: { completion in
                    
                    if case.finished = completion {
                        print("finished")
                    }
                    
                    if case .failure(let error) = completion {
                        receivedError = error
                        print("Error failure: \(error)")
                    }
                    expectation.fulfill()
                },
                receiveValue: { response in
                    print("Response received: \(response)")
                    receivedResponse = response
                    print("Received response: \(response)")
                }
//                receiveValue: { _ in
//                    receivedResponse = ()
//                }
            )
            .store(in: &cancellables)

        // Then
        //wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(receivedError)
       // XCTAssertNotNil(receivedResponse)
    }

    private func getBase64Image() -> String {
        let base64Image =  "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7/wAARCAAgACADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDwrNGaSq8ssiyEAjA9q+ZP16nTc3ZFnNGarRSu0gUkYPtVigKlN03ZhVaWN2kYhSQas0UBTqOm7orQxusikrgVZpKWgKlR1Hdn/9k="
        return base64Image
    }
}
