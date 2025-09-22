public struct SurveyQuery : Hashable, Decodable, Encodable {
    public let id: String
    public let query_no: Int
    public let query_type: QueryTypeEnum
    public let query_text: String

    public init(id: String, query_no: Int, query_type: QueryTypeEnum, query_text: String) {
        self.id = id
        self.query_no = query_no
        self.query_type = query_type
        self.query_text = query_text
    }
}