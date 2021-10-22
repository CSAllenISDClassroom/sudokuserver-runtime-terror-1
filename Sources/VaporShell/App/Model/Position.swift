public struct CartesianCoordinates: Hashable {
    public let rowIndex: Int
    public let colIndex: Int
}

public struct Position: Codable, Hashable {
    public let boxIndex: Int
    public let cellIndex: Int
}
