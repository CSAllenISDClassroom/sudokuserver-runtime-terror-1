class Collection {
    private var cells: Set<Cell> = []
    private var needs: Set<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9]

    init() {
        
    }

    init(cells: Set<Cell>) {
        self.cells = cells
    }

    func addCell(_ cell: Cell) {
        cells.insert(cell)
    }

    func addCells(_ cells: Set<Cell>) {
        self.cells.union(cells)
    }

    func removeNeed(value: Int) {
        needs.remove(value)
    }

    func getCell(position: Position) -> Cell? {
        var cellsFound = cells.filter{ $0.position == position }
        let possibleCell = cellsFound.popFirst()
        if(possibleCell != nil) {
            return possibleCell!
        }
        return nil
    }

    // func getCell(Position) -> Cell {
        // find cell
        // return cell if found
        // if not found, return error
    // }
}
