import Foundation
import MagnusDomain

public class MaterialsListHelper {

    public static func getGeneralMaterials(materials: [ConferenceMaterialListItem]) -> [ConferenceMaterialListItem] {
        let generalMaterials = materials.filter { $0.type == MaterialTypeEnum.generalMaterial }
        return generalMaterials
    }   
    
    public static func getEventMaterials(materials: [ConferenceMaterialListItem]) -> [ConferenceMaterialsDto] { 
        var events: [ConferenceMaterialsDto] = []

        let eventMaterials = materials.filter { $0.type == MaterialTypeEnum.eventMaterial }

        let eventMaterialsGroupedByEvent = Dictionary(grouping: eventMaterials) { $0.event_title }


        for (eventName, materials) in eventMaterialsGroupedByEvent {

            let firstMaterial = materials.first


            let eventMaterialsDto = ConferenceMaterialsDto(
                event_title: firstMaterial?.event_title ?? "", 
                date_from: firstMaterial?.date_from ?? "", 
                date_to: firstMaterial?.date_to ?? "", 
                eventMaterials: materials)
            events.append(eventMaterialsDto)
        }

        return events
    }   
    
}
