import Foundation

class Puzzle {
    // MARK: - Constants
    private struct Constants {
        static let blockSize = 3
        static var puzzleSize: Int {
            return blockSize * blockSize
        }
    }
    
    // MARK: - Properties
    private var data = [[Int?]]()
    var description: String {
        var description = ""
        for row in data {
            for square in row {
                if let squareValue = square {
                    description += "\(squareValue) "
                } else {
                    description += "- "
                }
            }
            description += "\n"
        }
        return description
    }
    
    // MARK: - Initializers
    init() {
        for _ in 0..<Constants.puzzleSize {
            var row = [Int?]()
            for _ in 0..<Constants.puzzleSize {
                row.append(nil)
            }
            data.append(row)
        }
    }
    
    convenience init(_ array: [[Int]]) {
        self.init()
        for row in array.enumerated() {
            for column in row.element.enumerated() {
                set(column: column.offset, row: row.offset, value: column.element)
            }
        }
    }
    
    // MARK: - Get and Set Functions
    private func copy() -> Puzzle {
        let copy = Puzzle()
        copy.data = self.data
        return copy
    }
    
    func set(column: Int, row: Int, value: Int) {
        guard column < Constants.puzzleSize
            && row < Constants.puzzleSize
            && value <= Constants.puzzleSize else { return }
        guard column >= 0
            && row >= 0
            && value > 0 else { return }
        data[row][column] = value
    }
    
    // MARK: - Validation Functions
    func number(ofValue value: Int, inRow row: Int) -> Int {
        let row = data[row]
        var count = 0
        for square in row where square == value {
            count += 1
        }
        return count
    }
    
    func number(ofValue value: Int, inColumn column: Int) -> Int {
        var count = 0
        for row in data where row[column] == value {
            count += 1
        }
        return count
    }
    
    func number(ofValue value: Int, atBlockColumn column: Int, blockRow row: Int) -> Int {
        var count = 0
        let blockRowStart = row/Constants.blockSize * Constants.blockSize
        for row in Array(data[blockRowStart..<blockRowStart+Constants.blockSize]) {
            let blockColumnStart = column/Constants.blockSize * Constants.blockSize
            for square in Array(row[blockColumnStart..<blockColumnStart+Constants.blockSize]) where square == value {
                count += 1
            }
        }
        return count
    }
    
    private func validate(value: Int, column: Int, row: Int, containsCount count: Int) -> Bool {
        guard number(ofValue: value, inRow: row) == count else { return false }
        guard number(ofValue: value, inColumn: column) == count else { return false }
        guard number(ofValue: value, atBlockColumn: column, blockRow: row) == count else { return false }
        return true
    }
    
    func validate() -> Bool {
        for row in data.enumerated() {
            for square in row.element.enumerated() {
                guard let value = square.element,
                    validate(value: value, column: square.offset, row: row.offset, containsCount: 1) else { return false }
            }
        }
        return true
    }
    
    // MARK: - Solving Functions
    func solve() {
        for row in 0..<Constants.puzzleSize {
            for column in 0..<Constants.puzzleSize
                where data[row][column] == nil {
                for value in 1...Constants.puzzleSize
                    where validate(value: value, column: column, row: row, containsCount: 0) {
                    let copy = self.copy()
                    copy.set(column: column, row: row, value: value)
                    copy.solve()
                    if copy.validate() {
                        self.data = copy.data
                        return
                    }
                }
                guard data[row][column] != nil else { return }
            }
        }
    }
}

let data1 = [
    [0, 0, 0, 0, 0, 1, 2, 3, 0],
    [1, 2, 3, 0, 0, 8, 0, 4, 0],
    [8, 0, 4, 0, 0, 7, 6, 5, 0],
    [7, 6, 5, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 2, 3],
    [0, 1, 2, 3, 0, 0, 8, 0, 4],
    [0, 8, 0, 4, 0, 0, 7, 6, 5],
    [0, 7, 6, 5, 0, 0, 0, 0, 0]
]
let puzzle1 = Puzzle(data1)

print("Original puzzle1 should not validate: \(puzzle1.validate() == false)")
puzzle1.solve()
print("Solved puzzle1 should validate:       \(puzzle1.validate())")

let data2 = [
    [6, 5, 7, 9, 4, 1, 2, 3, 8],
    [1, 2, 3, 6, 5, 8, 9, 4, 7],
    [8, 9, 4, 2, 3, 7, 6, 5, 1],
    [7, 6, 5, 1, 2, 3, 4, 8, 9],
    [2, 3, 1, 8, 9, 4, 5, 7, 6],
    [9, 4, 8, 7, 6, 5, 1, 2, 3],
    [5, 1, 2, 3, 7, 6, 8, 9, 4],
    [3, 8, 9, 4, 1, 2, 7, 6, 5],
    [4, 7, 6, 5, 8, 9, 3, 1, 2]
]
let puzzle2 = Puzzle(data2)

print("Original puzzle1 should validate:     \(puzzle2.validate())")
print("Both puzzles should be the same:      \(puzzle1.description == puzzle2.description)")
