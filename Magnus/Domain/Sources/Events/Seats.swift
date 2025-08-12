public struct Seats: Decodable {
    public let total: Int
    public let taken: Int
    public let unconfirmed: Int

    public init(total: Int, taken: Int, unconfirmed: Int) {
        self.total = total
        self.taken = taken
        self.unconfirmed = unconfirmed
    }

    public var available: Int {
        return total - taken - unconfirmed
    }

    public var isFull: Bool {
        return available == 0
    }
}
    