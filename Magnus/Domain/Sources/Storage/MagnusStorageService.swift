import Foundation

public protocol MagnusStorageService {
    func saveEventDetails(_ eventDetails: ConferenceEventDetails) throws
    func getEventDetails() throws -> ConferenceEventDetails?
    func saveNewsRequest(news: AddNewsRequest) throws
    func getNewsRequest() throws -> AddNewsRequest?
    func saveAgendaItem(agendaItem: ConferenceEventAgendaContent) throws
    func getAgendaItem() throws -> ConferenceEventAgendaContent?
    func saveLocation(location: ConferenceEventLocation) throws
    func getLocation() throws -> ConferenceEventLocation?
}