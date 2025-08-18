import Foundation

public protocol MagnusStorageService {
    func saveEventDetails(_ eventDetails: ConferenceEventDetails) throws
    
    func getEventDetails() throws -> ConferenceEventDetails?
}