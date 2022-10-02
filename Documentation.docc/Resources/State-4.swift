import Decore

struct Title: GroupContainer {
    typealias Element = String
    typealias ID = Int

    static func initialValue(for id: ID) -> Element {
        "A shiny new todo item!"
    }
}

struct IsComplete: GroupContainer {
    typealias Element = Bool
    typealias ID = Int

    static func initialValue(for id: ID) -> Element {
        false
    }
}

struct AllTodos: Container {
    typealias Value = [Int]

    static func initialValue() -> Value {
        []
    }
}

struct NewID: Computation {
    typealias Value = Int

    static func value(read: Storage.Reader) -> Value {
        // reading the value for AllTodos container
        let all = read(AllTodos.self)
        // finding the maximum index in the array
        let biggestIndex = all.reduce(into: 0) { acc, el in
            acc = max(acc, el)
        }
        // return next after the biggest index
        return biggestIndex + 1
    }
}