import Decore

enum TodoItem {}

extension TodoItem {

    /// Todo item title
    struct Title: GroupContainer {
        typealias Element = String
        typealias ID = Int

        static func initialValue(for id: ID) -> Element {
            "A shiny new todo item!"
        }
    }

    /// Todo item completion status
    struct IsComplete: GroupContainer {
        typealias Element = Bool
        typealias ID = Int

        static func initialValue(for id: ID) -> Element {
            false
        }
    }

}
