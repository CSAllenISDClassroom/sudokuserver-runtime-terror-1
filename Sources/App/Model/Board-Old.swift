class Board {

    private(set) var values : [[Int]] = []

    init() {
        generate()
    }

    func generate() {
        var boardValues : [[Int]] = []
        let firstRow = generateRow()

        boardValues.append(firstRow)
        for row in 2...9 {
            let previousRow = boardValues[row - 2]
            var currentRow : [Int]
            let specialRows = [4, 7]
            if(specialRows.contains(row)) {
                let firstThreeValues = Array(firstRow[0...2])
                let secondThreeValues = Array(firstRow[3...5])
                let thirdThreeValues = Array(firstRow[6...8])
                let shiftValue = row == 4 ? 1 : 2
                currentRow = firstThreeValues.shift(withDistance: shiftValue)
                currentRow.append(contentsOf: secondThreeValues.shift(withDistance: shiftValue))
                currentRow.append(contentsOf: thirdThreeValues.shift(withDistance: shiftValue))
            } else {
                currentRow = previousRow.shift(withDistance: 3)
            }

            boardValues.append(currentRow)
        }
        self.values = boardValues
        randomize()
    }

    func randomize() {
        let firstTriplets = values[0...2].shuffled()
        let secondTriplets = values[3...5].shuffled()
        let thirdTriplets = values[6...8].shuffled()
        let randomlyOrderedTriplets = [firstTriplets, secondTriplets, thirdTriplets].shuffled()
        var randomizedBoard : [[Int]] = []
        for triplet in randomlyOrderedTriplets {
            for row in triplet {
                randomizedBoard.append(row)
            }
        }
        self.values = randomizedBoard
    }

    func generateRow() -> [Int] {
        var values = Set<Int>()
        for value in 1...9 {
            values.insert(value)
        }
        let valuesInRandomOrder = Array(values).shuffled()
        return valuesInRandomOrder
    }

    func setValues(values: [[Int]]) {
        self.values = values
    }

    func putValue(row: Int, col: Int, value: Int) {
        values[row][col] = value
    }

    func log() {
        for row in values {
            print(row)
        }
    }
}

extension Array {

            /**
                           Returns a new array with the first elements up to specified distance being shifted to the end of the collection. If the distance is negative, returns a new array with the last elements up to the specified absolute distance being shifted to the beginning of the collection.
                                              If the absolute distance exceeds the number of elements in the array, the elements are not shifted.
             */
    func shift(withDistance distance: Int = 1) -> Array<Element> {
        let offsetIndex = distance >= 0 ?
          self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
          self.index(endIndex, offsetBy: distance, limitedBy: startIndex)

        guard let index = offsetIndex else { return self }
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }

        /**
                   Shifts the first elements up to specified distance to the end of the array. If the distance is negative, shifts the last elements up to the specified absolute distance to the beginning of the array.
                                  If the absolute distance exceeds the number of elements in the array, the elements are not shifted.
         */
    mutating func shiftInPlace(withDistance distance: Int = 1) {
        self = shift(withDistance: distance)
    }

}
