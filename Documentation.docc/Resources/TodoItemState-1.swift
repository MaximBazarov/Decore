import Decore

enum Todo {}

extension Todo {

    /// Todo item title
    struct Title: GroupContainer {
        typealias Element = String
        typealias ID = Int

        static func initialValue(for id: ID) -> Element {
            "A shiny new todo item!"
        }
    }
    
}
