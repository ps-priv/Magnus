import Foundation

public protocol MagnusStorageService {
    func saveEventDetails(_ eventDetails: ConferenceEventDetails) throws
    func getEventDetails() throws -> ConferenceEventDetails?
    func saveNewsRequest(news: AddNewsRequest) throws
    func getNewsRequest() throws -> AddNewsRequest?
}