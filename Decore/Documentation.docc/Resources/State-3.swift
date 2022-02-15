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
