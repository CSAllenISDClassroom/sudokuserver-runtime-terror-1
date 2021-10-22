
/// JSON ENCODING ///

public struct BoardId: Codable {
    let id: Int
}

/// JSON DECODING ///

public struct CellValue: Decodable {
    let value: Int?

    func checkValue() -> Bool {
        var goodValues: Set<Int?> = [nil]
        for n in 1...9 {
            goodValues.insert(n)
        }
        return goodValues.contains(value)
    }
}
