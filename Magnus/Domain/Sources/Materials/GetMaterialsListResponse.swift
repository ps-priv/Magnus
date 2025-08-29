public struct GetMaterialsListResponse: Hashable, Decodable {
    public let materials: [ConferenceMaterialListItem]

    public init(materials: [ConferenceMaterialListItem]) {
        self.materials = materials
    }
}